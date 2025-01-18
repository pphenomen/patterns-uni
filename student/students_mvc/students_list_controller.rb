require_relative '../lib/students_list'

class StudentsListController
	attr_reader :view, :students_list, :data_list

	def initialize(view)
	    @view = view
	    @view.controller = self
	    @students_list = StudentsList.new(filepath: '../data/students.yaml', strategy: YAMLFileStrategy.new)
	    @data_list = nil
		load_data
	end

	def load_data
	    @students_list.read
	    refresh_data
	end

	def refresh_data
	    filters = collect_filters
	    filtered_students = apply_filters(@students_list.students, filters)

	    whole_entities_count = filtered_students.size
	    @total_pages = [(whole_entities_count.to_f / @view.students_per_page).ceil, 1].max

    	start_index = (@view.current_page - 1) * @view.students_per_page
    	paginated_students = filtered_students[start_index, @view.students_per_page] || []

	    @data_list = DataListStudentShort.new(paginated_students.map { |s| StudentShort.from_student(s) })
	    @data_list.view = @view
	    @data_list.notify
	end

	private
	
	def collect_filters
	    {
	      fio: @view.instance_variable_get(:@fio_field).text.strip,
	      git: fetch_combo_filter(@view, "Git"),
	      contact: fetch_combo_filter(@view, "Контакт")
	    }
	end

	def fetch_combo_filter(view, field_name)
	    field_combo = view.instance_variable_get(:@filters)["#{field_name}_combo"]
	    field_input = view.instance_variable_get(:@filters)["#{field_name}_input"]

	    {
	        combo_value: field_combo.getItemText(field_combo.currentItem).strip,  
	        value: field_input.text.strip
	    }
	end

	def apply_filters(students, filters)
	    filtered = students.dup

	    # Фильтр по ФИО
	    unless filters[:fio].empty?
	      filtered.select! { |student| student.surname_initials.downcase.include?(filters[:fio].downcase) }
	      if filtered.empty?
            FXMessageBox.warning(@view, MBOX_OK, "Поиск", "Студент с таким ФИО не найден.")
            return students
          end
	    end

	    # Фильтр по Git
	    case filters[:git][:combo_value]
	    when "Да"
	        filtered.select! { |student| student.git && student.git.include?(filters[:git][:value]) }
	    when "Нет"
	        filtered.select! { |student| student.git.nil? || student.git.empty? }
	    end

	    # Фильтр по Контакту
	    case filters[:contact][:combo_value]
	    when "Да"
	        filtered.select! { |student| student.contact && student.contact.include?(filters[:contact][:value]) }
	    when "Нет"
	        filtered.select! { |student| student.contact.nil? || student.contact.empty? }
	    end

	    if filtered.empty?
	        FXMessageBox.warning(@view, MBOX_OK, "Фильтр", "Нет студентов, соответствующих фильтру.")
	        return students
	    end

	    filtered
	end
end
