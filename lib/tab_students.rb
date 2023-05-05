# frozen_string_literal: true

# frozen_string_literal: true
require 'glimmer-dsl-libui'
require_relative 'student_list_controller'
require_relative 'student_input_form'

class TabStudents
  include Glimmer
  STUDENTS_PER_PAGE = 20

  def initialize
    @controller = StudentListController.new(self)
    @current_page = 1
    @total_count = 0
  end

  def on_create
    @controller.on_view_created
    @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
  end

  # Метод наблюдателя datalist
  def on_datalist_changed(new_table)
    arr = new_table.to_2d_array
    @table.model_array = arr
  end

  def update_student_count(new_cnt)
    @total_count = new_cnt
    @page_label.text = "#{@current_page} / #{(@total_count / STUDENTS_PER_PAGE.to_f).ceil}"
  end

  def create
    root = horizontal_box {
      # Секция 1
      vertical_box {
        stretchy false

        form {
          stretchy false

          @filter_last_name_initials = entry {
            label 'ФИО'
          }

          @filters = {}
          fields = [[:git, 'Github'], [:email, 'Почта'], [:phone, 'Телефон'], [:telegram, 'Телеграм']]

          fields.each do |field|
            @filters[field[0]] = {}

            @filters[field[0]][:combobox] = combobox {
              label "#{field[1]}?"
              items ['Не важно', 'Есть', 'Нет']
              selected 0

              on_selected do
                if @filters[field[0]][:combobox].selected == 1
                  @filters[field[0]][:entry].read_only = false
                else
                  @filters[field[0]][:entry].text = ''
                  @filters[field[0]][:entry].read_only = true
                end
              end
            }

            @filters[field[0]][:entry] = entry {
              label field[1]
              read_only true
            }
          end
        }
      }

      # Секция 2
      vertical_box {
        @table = refined_table(
          table_editable: false,
          filter: lambda do |row_hash, query|
            utf8_query = query.force_encoding("utf-8")
            row_hash['Фамилия И. О'].include?(utf8_query)
          end,
          table_columns: {
            '#' => :text,
            'Фамилия И. О' => :text,
            'Гит' => :text,
            'Контакт' => :text,
          },
          per_page: STUDENTS_PER_PAGE
        )

        @pages = horizontal_box {
          stretchy false

          button("<") { stretchy true }
          button("<") {
            stretchy true

            on_clicked do
              @current_page = [@current_page - 1, 1].max
              @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
            end

          }
          @page_label = label("...") { stretchy false }
          button(">") { stretchy true }
          button(">") {
            stretchy true

            on_clicked do
              @current_page = [@current_page + 1, (@total_count / STUDENTS_PER_PAGE.to_f).ceil].min
              @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
            end
          }
        }
      }

      # Секция 3
      vertical_box {
        stretchy true

        button('Добавить') {
          stretchy false

          on_clicked {
            @controller.show_modal_add
          }
        }
        button('Изменить') {
          stretchy false

          on_clicked {
            @controller.show_modal_edit(@current_page, STUDENTS_PER_PAGE, @table.selection) unless @table.selection.nil?
          }
        }
        button('Удалить') {
          stretchy false

          on_clicked {
            @controller.delete_selected(@current_page, STUDENTS_PER_PAGE, @table.selection) unless @table.selection.nil?
            @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
          }
        }
        button('Обновить') { stretchy false }
      }
    }
    on_create
    root
  end

end