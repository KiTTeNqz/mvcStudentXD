# frozen_string_literal: true

# frozen_string_literal: true
require_relative 'student_list_adv'
require_relative 'adapters/student_list_adapter'
require_relative 'database/student_list_db'
require_relative 'converters/Converter_json'
require_relative 'converters/Converter'
require_relative 'Student_list'
require_relative 'student_edit_form_controller'
require 'win32api'
require 'mysql2'
require_relative '../../mvcStudentXD/lib/util/LoggerHolder'
class StudentListController
  def initialize(view)
    LoggerHolder.instance.debug('StudentListController: init start')
    @view = view
    @data_list = DataListStudentShort.new
    @data_list.add_listener(@view)
    LoggerHolder.instance.debug('StudentListController: init done')
  end

  def on_view_created
    begin
      @student_list = StudentListAdv.new(StudentsListDBAdapter.new(StudentListDB.instance))
      LoggerHolder.instance.debug('StudentListController: created student repository')
    rescue Mysql2::Error::ConnectionError=>e
      on_db_conn_error(e)
    end
  end

  def delete_selected(current_page, per_page, selected_row)
    begin
      LoggerHolder.instance.debug('StudentListController: deleting selected student')
      student_num = (current_page - 1) * per_page + selected_row
      @data_list.select_element(student_num)
      student_id = @data_list.selected_id
      @student_list.remove_student(student_id)
    rescue => e
      on_db_conn_error(e)
    end
  end

  def show_modal_add
    LoggerHolder.instance.debug('StudentListController: showing modal (add)')
    controller = StudentInputFormController.new(self)
    view = StudentInputForm.new(controller)
    controller.set_view(view)
    view.create.show
  end

  def show_modal_edit(current_page, per_page, selected_row)
    LoggerHolder.instance.debug('StudentListController: showing modal (edit)')
    student_num = (current_page - 1) * per_page + selected_row
    @data_list.select_element(student_num)
    student_id = @data_list.selected_id
    controller = StudentEditFormController.new(self, student_id)
    view = StudentInputForm.new(controller)
    controller.set_view(view)
    view.create.show
  end

  def refresh_data(page, per_page)
    begin
      @data_list = @student_list.get_students_pag(page, per_page, @data_list)
      @view.update_student_count(@student_list.count)
    rescue => e
      on_db_conn_error(e)
    end
  end

  private
  def on_db_conn_error(error)
    LoggerHolder.instance.error('TabStudentsController: DB connection error:')
    LoggerHolder.instance.error(error.message)
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    # TODO: Возможность переключения на JSON помимо exit
    exit(false)
  end
end
