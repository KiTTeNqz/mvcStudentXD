# frozen_string_literal: true

class StudentEditFormController
  def initialize(parent_controller, existing_student_id)
    @parent_controller = parent_controller
    @existing_student_id = existing_student_id
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
    @existing_student = @student_list.get_student(@existing_student_id)
    @view.make_readonly(:git, :telegram, :email, :phone)
    print("IM IN ONVIEW EDIT")
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
      print("IM IN PROCESS EDIT")
      @student_list.replace_student(@existing_student_id, new_student)

      @view.close
    rescue ArgumentError => e
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, e.message, 'Error', 0)
    end
  end

  private

  def on_db_conn_error
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    @view.close
  end
end
