require_relative 'data_list'
require_relative 'data_table'

class DataListStudentShort < DataList
	attr_accessor :count

	def initialize(data)
		super(data)
		@observers = []
	end

	def add_observer(observer)
        @observers << observer
    end

    def remove_observer(observer)
        @observers.delete(observer)
    end

    def notify
        @observers.each do |observer|
          observer.set_table_params(column_names, @count)
          observer.set_table_data(get_data)
        end
    end
  	
	private

	def column_names
		["№", "Фамилия И.О.", "Git", "Контакт"]
	end

	def get_objects_array
		raise ArgumentError, "Данные отсутствуют" if data.empty?
		data.map.with_index(1) do |object, index|
			[index, object.surname_initials, object.git, object.contact]
		end
	end
end