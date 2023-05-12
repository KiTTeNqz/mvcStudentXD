# frozen_string_literal: true

require 'win32api'
require_relative '../../mvcStudentXD/lib/util/LoggerHolder'
class StudentInputFormController
  def initialize(parent_controller)
    @parent_controller = parent_controller
    LoggerHolder.instance.debug('StudentInputFormController: initialized')
  end

  def set_view(view)
    @view = view
  end


  def refresh
    @parent_controller.refresh_data(1,20)
  end

  def on_view_created
    begin
      @student_list = StudentListAdv.new(StudentsListDBAdapter.new(StudentListDB.instance))
    rescue Mysql2::Error::ConnectionError=>e
      on_db_conn_error(e)
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
      LoggerHolder.instance.debug('StudentInputFormController: adding student to DB')
      @view.close
    rescue ArgumentError => e
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      LoggerHolder.instance.debug("StudentInputFormController: wrong fields: #{e.message}")
      api.call(0, e.message, 'Error', 0)
    end
  end


  def on_db_conn_error(error)
    LoggerHolder.instance.debug('StudentInputFormController: DB connection error:')
    LoggerHolder.instance.error(error.message)
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    @view.close
  end
end
