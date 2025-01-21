class DataList
	attr_reader :data, :selected, :column_names

	def initialize(data)
		self.data = data
		@column_names = column_names
		@selected = []
	end

	def set_data(new_data)
		raise ArgumentError, "Объект должен являться массивом" unless new_data.is_a?(Array)
		self.data = new_data
	end

	def select(number)
		raise ArgumentError, "Индекс выходит за пределы" unless number.between?(0, data.size - 1)

		selected.clear
		selected << number
	end

	def get_selected
		selected
	end

	def build_table
		[get_columns] + get_data
	end

	def get_columns
		column_names
	end

	def get_data
		get_objects_array
	end

	def data=(data)
		raise ArgumentError, "Объект должен являться массивом" unless data.is_a?(Array)
		@data = data
	end

	private

	def column_names
		raise NotImplementedError, "Метод не реализован в классе"
	end

	def get_objects_array
		raise NotImplementedError, "Метод не реализован в классе"
	end
end