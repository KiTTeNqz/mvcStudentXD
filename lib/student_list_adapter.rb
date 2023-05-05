# frozen_string_literal: true
require_relative 'Student_list'
class StudentsListAdapter
  private_class_method :new
  def get_student(id)
  end

  def remove_student(id)
  end

  def replace_student(id, student)
  end

  def get_students_pag(k, n, data)
  end

  def add_student(student)
  end

  def count
  end
end

class StudentsListDBAdapter < StudentsListAdapter
  private
  attr_accessor :database_list

  public_class_method :new
  
  public
  def initialize(database_list)
    self.database_list = database_list
  end

  def get_student(id)
    database_list.get_student(id)
  end

  def remove_student(id)
    database_list.remove_student(id)
  end

  def replace_student(id, student)
    database_list.replace_student(id, student)
  end

  def get_students_pag(from, to, data)
    database_list.get_students_pag(from, to, data)
  end

  def add_student(student)
    database_list.add_student(student)
  end

  def count
    database_list.count
  end
end

class StudentsListConverterAdapter < StudentsListAdapter
  private
  attr_accessor :file_list

  public_class_method :new
  
  public
  def initialize(file_list, filename)
    self.file_list = file_list
    self.file_list.read_file(filename)
  end

  def get_student(id)
    file_list.get_student(id)
  end

  def remove_student(id)
    file_list.remove_student(id)
  end

  def replace_student(id, student)
    file_list.replace_student(id, student)
  end

  def get_students_pag(k, n, data=nil)
    file_list.get_students_pag(k, n, data)
  end

  def add_student(student)
    file_list.add_student(student)
  end

  def count
    file_list.count
  end
end
