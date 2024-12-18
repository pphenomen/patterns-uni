require_relative 'data_list'
require_relative 'data_table'

class DataListStudentShort < DataList
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