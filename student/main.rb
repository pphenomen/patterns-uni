require_relative './models/person'
require_relative './models/student'
require_relative './models/student_short'
require_relative './tree/student_binary_tree'
require_relative './lib/data_table'
require_relative './lib/data_list'
require_relative './lib/data_list_student_short'
require_relative './lib/students_list'
require_relative './strategy/file_strategy'
require_relative './strategy/yaml_file_strategy'
require_relative './strategy/json_file_strategy'
require_relative './db/students_list_db'
require_relative './db/dbconfig'
require_relative './adapter/students_list_adapter'
require_relative './adapter/students_list_db_adapter'
require 'json'
require 'yaml'

student1 = Student.new(
  id: 1,
  second_name: 'Иванов',
  first_name: 'Павел',
  patronymic: 'Иванович',
  birthdate: '1999-05-06',
  phone_number: '89761235689',
  email: 'pivanov@example.com',
  telegram: 'pivanov',
  git: 'https://github.com/pivanov'
)

student2 = Student.new(
  id: 2,
  second_name: 'Петров',
  first_name: 'Геогрий',
  patronymic: 'Петрович',
  birthdate: '1997-10-07',
  phone_number: '89652138754',
  email: 'geopetr@example.com',
  telegram: 'geopetr',
  git: 'https://github.com/geopetr'
)

# student3 = Student.new(
#   second_name: 'Смирнова',
#   first_name: 'Мария',
#   patronymic: 'Ивановна',
#   birthdate: '1997-03-09',
#   phone_number: '89164445566',
#   email: 'smirnova@example.com',
#   telegram: 'smirnova_maria',
#   git: 'https://github.com/smirnova'
# )

# tree = StudentBinaryTree.new
# tree.insert(student1)
# tree.insert(student2)
# tree.insert(student3)

# puts "\nОтсортированные даты рождения студентов по возрастанию:"
# tree.each { |student| puts student }

# def adapter(filepath:, strategy:, students:)
#   students_list = StudentsList.new(filepath: filepath, strategy: strategy)

#   students.each do |student|
#     students_list.add_student(student)
#   end

#   puts "Список студентов:"
#   puts students_list.get_k_n_student_short_list(1, 10).inspect
# end

# adapter(filepath: filepath, strategy: strategy, students: [student1, student2])

# filepath1 = 'data/students.json'
# strategy1 = JSONFileStrategy.new
# filepath2 = 'data/students.yaml'
# strategy2 = YAMLFileStrategy.new
# students_list = StudentsList.new(filepath: filepath2, strategy: strategy2)

# begin
#   students_list.add_student(student1)
#   students_list.add_student(student2)
#   students_list.write
#   puts "Студенты записаны в файл: #{filepath2}"

#   students_list.read
#   puts "Список студентов после чтения из файла:"
#   students_list.students.each do |student|
#     puts "#{student.id}. #{student.surname_initials} - Git: #{student.git}, Email: #{student.email}"
#   end
# rescue => e
#   puts "Ошибка: #{e.message}"
# end

# repeat_student = Student.new(
#   id: 1,
#   second_name: 'Иванов',
#   first_name: 'Иван',
#   patronymic: 'Иванович',
#   birthdate: '2000-01-01',
#   phone_number: '89012345678',
#   email: 'ivanov@example.com',
#   telegram: 'ivan_telegram',
#   git: 'https://github.com/ivan'
# )
# db_config = DBConfig.instance

# con = StudentsListDB.new(db_config)
# con.add_student(repeat_student) # => error

repeat_student = Student.new(
  id: 1,
  second_name: 'Иванов',
  first_name: 'Павел',
  patronymic: 'Иванович',
  birthdate: '1999-05-06',
  phone_number: '89761235689',
  email: 'pivanov@example.com',
  telegram: 'pivanov',
  git: 'https://github.com/pivanov'
)

puts student1 == repeat_student # => true

# прочитать из json в yaml
filepath1 = 'data/students.json'
strategy1 = JSONFileStrategy.new

students_list = StudentsList.new(filepath: filepath1, strategy: strategy1)
students_list.read

filepath2 = 'data/students.yaml'
strategy2 = YAMLFileStrategy.new

students_list_yaml = StudentsList.new(filepath: filepath2, strategy: strategy2)
students_list_yaml.students = students_list.students
students_list_yaml.write

puts "Студенты записаны в YAML: #{filepath2}"
