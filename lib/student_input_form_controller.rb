# frozen_string_literal: true

require 'win32api'

class StudentInputFormController
  def initialize(parent_controller)
    @parent_controller = parent_controller
  end

  def set_view(view)
    @view = view
  end

  def on_view_created
    begin
      @student_list = StudentListAdv.new(StudentsListDBAdapter.new(StudentListDB.instance))
    rescue Mysql2::Error::ConnectionError
      on_db_conn_error
    end
  end

  def process_fields(fields)
    begin
      last_name = fields.delete(:last_name)
      first_name = fields.delete(:first_name)
      parental_name = fields.delete(:parental_name)

      return if last_name.nil? || first_name.nil? || parental_name.nil?

      student = Student.new(last_name, first_name, parental_name, **fields)

      @student_list.add_student(student)

      @view.close
    rescue ArgumentError => e
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, e.message, 'Error', 0)
    end
  end


  def on_db_conn_error
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    @view.close
  end
end
