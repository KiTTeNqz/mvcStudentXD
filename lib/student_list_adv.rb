# frozen_string_literal: true

class StudentListAdv
  private
  attr_accessor :students_list_adapter
  public
  def initialize(students_list_adapter)
    self.students_list_adapter = students_list_adapter
  end

  def get_student(id)
    students_list_adapter.get_student(id)
  end

  def remove_student(id)
    students_list_adapter.remove_student(id)
  end

  def replace_student(id, student)
    students_list_adapter.replace_student(id, student)
  end

  def get_students_pag(k, n, data)
    students_list_adapter.get_students_pag(k, n, data)
  end

  def add_student(student)
    students_list_adapter.add_student(student)
  end

  def count
    students_list_adapter.count
  end

end
