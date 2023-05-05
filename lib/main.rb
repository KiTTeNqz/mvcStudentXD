require_relative 'Student'
require_relative 'Student_short'
require_relative 'Data_list'
require_relative 'Data_list_student_short'
require_relative 'Student_list'
require_relative 'Converter_yaml'
require_relative 'Converter_txt'
require_relative 'Converter_json'
require_relative 'database/student_list_db'
require_relative 'student_list_adv.rb'
require_relative 'student_list_adapter.rb'
require 'mysql2'

db = StudentListDB.instance
puts db.get_student(2)
puts db.count

studentsList = StudentListAdv.new(StudentsListDBAdapter.new(StudentListDB.instance))
json = StudentList.new(ConverterJSON.new)
studentsList2 = StudentListAdv.new(StudentsListConverterAdapter.new(json, 'C:/Users/Дмитрий/RubymineProjects/RubyLabs/Lab2/studentsRead.json'))
puts studentsList.get_student(3)

puts studentsList2.get_student(2)