# frozen_string_literal: true
require_relative '../../mvcStudentXD/lib/util/LoggerHolder'
class StudentEditFormController
  def initialize(parent_controller, existing_student_id)
    @parent_controller = parent_controller
    @existing_student_id = existing_student_id
    LoggerHolder.instance.debug('StudentEditFormController: initialized')
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
    @existing_student = @student_list.get_student(@existing_student_id)

    @view.make_readonly(:git, :telegram, :email, :phone)
    populate_fields(@existing_student)
  end

  def populate_fields(student)
    @view.set_value(:last_name, student.last_name)
    @view.set_value(:first_name, student.first_name)
    @view.set_value(:parental_name, student.parental_name)
    @view.set_value(:git, student.git)
    @view.set_value(:telegram, student.telegram)
    @view.set_value(:email, student.email)
    @view.set_value(:phone, student.phone)
    print("IM IN Populate EDIT")
  end

  def process_fields(fields)
    begin
      new_student = Student.from_hash(fields)
      @student_list.replace_student(@existing_student_id, new_student)
      LoggerHolder.instance.debug('StudentEditFormController: replacing student in DB')
      @view.close
    rescue ArgumentError => e
      LoggerHolder.instance.debug("StudentEditFormController: wrong fields: #{e.message}")
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, e.message, 'Error', 0)
    end
  end

  private

  def on_db_conn_error(error)
    LoggerHolder.instance.debug('StudentEditFormController: DB connection error:')
    LoggerHolder.instance.error(error.message)
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    @view.close
  end
end
