require_relative '../lib/students_list'
require_relative '../lib/data_list_student_short'

class StudentsListController
	attr_reader :view, :students_list
	attr_accessor :data_list

	def initialize(view)
	    @view = view
	    @view.controller = self
	    @students_list = StudentsList.new(filepath: '../data/students.yaml', strategy: YAMLFileStrategy.new)
	    @data_list = DataListStudentShort.new([])
		load_data
	end

	def load_data
	    @students_list.read
	    refresh_data
	end

	def refresh_data
	    @data_list = @students_list.get_k_n_student_short_list(@view.current_page, @view.students_per_page)
	    @data_list.count = @students_list.get_student_short_count
	    @data_list.add_observer(@view)
	    @data_list.notify
	end
end
