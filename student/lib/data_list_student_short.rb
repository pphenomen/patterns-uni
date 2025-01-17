require_relative 'data_list'
require_relative 'data_table'

class DataListStudentShort < DataList
	attr_accessor :view
	
	def set_offset(offset)
    	@offset = offset
  	end

	def notify
	    @view.set_table_params(column_names, self.data.size)
	    @view.set_table_data(build_table)
	end
  	
	private

	def column_names
		["№", "Фамилия И.О.", "Git", "Контакт"]
	end

	def get_objects_array
		raise ArgumentError, "Данные отсутствуют" if data.empty?
		data.map.with_index(1) do |object, index|
			[index + (@offset || 0), object.surname_initials, object.git, object.contact]
		end
	end
end