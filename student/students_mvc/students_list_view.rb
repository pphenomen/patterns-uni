require 'fox16'
require_relative 'students_list_controller'
require_relative '../lib/data_list'

include Fox

class StudentsListView < FXMainWindow
	attr_accessor :students_per_page, :current_page, :controller

  	def initialize(app, controller: nil)
	    super(app, "Список студентов", width: 1024, height: 768)
	    @students_per_page = 20
	    @current_page = 1
		@controller = StudentsListController.new(self)

    	create_main_layout
    	create_filter_section
    	create_table_section
    	create_pagination_controls
    	create_control_buttons

    	show(PLACEMENT_SCREEN)
  	end

  	def set_table_params(column_names, whole_entities_count)
  		return unless @table

	    @table.setTableSize(0, column_names.size)
	  	column_names.each_with_index { |name, index| @table.setColumnText(index, name) }

	  	@total_pages = (whole_entities_count.to_f / @students_per_page).ceil
	  	@page_label.text = "Страница #{@current_page} из #{@total_pages}"
	end

	def set_table_data(data_table)
		return unless @table && !data_table.nil? && !data_table.empty?

	    @table.setTableSize(data_table.size, data_table.first.size)
	    data_table.each_with_index do |row, i|
	    	row.each_with_index do |value, j|
	        	@table.setItemText(i, j, value.to_s)
	      	end
	    end
	    adjust_column_widths
	end

	def refresh_view
	    @controller.refresh_data if @controller
	end

	private

  	def create_main_layout
	    @sections = FXTabBook.new(self, opts: LAYOUT_FILL)
	    FXTabItem.new(@sections, "Список студентов")
	    @student_list_view = FXVerticalFrame.new(@sections, opts: LAYOUT_FILL)
  	end

  	def create_filter_section
	    filter_frame = FXGroupBox.new(@student_list_view, "Фильтрация", opts: GROUPBOX_NORMAL | LAYOUT_FILL_X)
	    FXLabel.new(filter_frame, "ФИО:")
	    @fio_field = FXTextField.new(filter_frame, 25)

	    @filters = {}

	    %w[Git Контакт].each do |field|
	      	field_frame = FXHorizontalFrame.new(filter_frame, opts: LAYOUT_FILL_X)
	      	FXLabel.new(field_frame, "#{field}:")
	      
	      	combo = FXComboBox.new(field_frame, 15, opts: COMBOBOX_STATIC | FRAME_SUNKEN | FRAME_THICK)
	      	combo.numVisible = 3
	      	combo.appendItem("Да")
	      	combo.appendItem("Нет")
	      	combo.appendItem("Неважно")
	      	combo.setCurrentItem(2)

	      	field_input = FXTextField.new(field_frame, 25, opts: TEXTFIELD_NORMAL | TEXTFIELD_READONLY)

	      	combo.connect(SEL_COMMAND) do
	        	field_input.enabled = combo.currentItem == 0
	        	field_input.text = "" unless field_input.enabled
	      	end

	      	@filters["#{field}_combo"] = combo
    		@filters["#{field}_input"] = field_input
	    end
  	end

  	def create_table_section
    	table_frame = FXGroupBox.new(@student_list_view, "Список студентов", opts: GROUPBOX_NORMAL | LAYOUT_FILL)
	    @table = FXTable.new(table_frame, opts: LAYOUT_FILL)
	    @table.setTableSize(0, 4)
	    @table.editable = false
  	end

  	def create_pagination_controls
	    pagination_frame = FXHorizontalFrame.new(@student_list_view, opts: LAYOUT_FILL_X)
	    @page_label = FXLabel.new(pagination_frame, "Страница #{@current_page} из #{@total_pages}", opts: LAYOUT_CENTER_X)

	    @prev_button = FXButton.new(pagination_frame, "Назад", nil, nil, 0, opts: BUTTON_NORMAL)
    	@next_button = FXButton.new(pagination_frame, "Вперед", nil, nil, 0, opts: BUTTON_NORMAL)

    	@prev_button.connect(SEL_COMMAND) { go_to_the_prev_page }
    	@next_button.connect(SEL_COMMAND) { go_to_the_next_page }
  	end
  	
  	def create_control_buttons
    	control_frame = FXHorizontalFrame.new(@student_list_view, opts: LAYOUT_FILL_X)

    	@add_button = FXButton.new(control_frame, "Добавить", opts: BUTTON_NORMAL)
    	@edit_button = FXButton.new(control_frame, "Изменить", opts: BUTTON_NORMAL)
    	@delete_button = FXButton.new(control_frame, "Удалить", opts: BUTTON_NORMAL)
    	@update_button = FXButton.new(control_frame, "Обновить", opts: BUTTON_NORMAL).connect(SEL_COMMAND) { refresh_view }
  	end

  	def go_to_the_next_page
  		if @current_page < @total_pages
  			@current_page += 1
			refresh_view
	    end
	end

	def go_to_the_prev_page
  		if @current_page > 1
  			@current_page -= 1
	        refresh_view
	    end
	end

	def adjust_column_widths
	    (0...@table.numColumns).each do |col|
	        max_width = 0

	        (0...@table.numRows).each do |row|
	            cell_text = @table.getItemText(row, col)
	            text_width = cell_text.length * 8
	            max_width = [max_width, text_width].max
	        end

	        @table.setColumnWidth(col, max_width)
	    end
	end
end