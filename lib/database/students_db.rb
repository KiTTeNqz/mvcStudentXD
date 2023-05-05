# frozen_string_literal: true
# #encoding: UTF-8
require 'mysql2'
require_relative '../Data_list_student_short'
require_relative '../Data_list'
require_relative '../Student'
require_relative '../Student_short'
class StudentDB

  attr_accessor :db_connection

  def initialize
    self.db_connection = Mysql2::Client.new(:host => "localhost", :username => "dimas", :password => "qwe123")
    self.db_connection.query('CREATE DATABASE IF NOT EXISTS stud_db')
    self.db_connection.query('USE stud_db')
    self.db_connection.query('DROP TABLE IF EXISTS student')
    self.db_connection.query(File.read('C:/Users/Dmitry/RubymineProjects/RubyLabs/Lab2/database/scripts/create_table.sql'))
    self.insert_data
  end

  def insert_data
    db_connection.query(File.read('C:/Users/Dmitry/RubymineProjects/RubyLabs/Lab2/database/scripts/insert_data.sql'))
  end

  def select_by_id(id)
    db_connection.query("SELECT * FROM student WHERE id = #{id}").map{|x| x}[0]
  end

  def remove_by_id(id)
    db_connection.query("DELETE FROM student WHERE id = #{id}")
  end

 def parseNil(attr)
    if attr == nil
      "NULL"
    else
      attr
    end
  end

  def add_student(student_data)

    db_connection.query("""
        INSERT INTO student (last_name, first_name, parental_name, git, phone, email, telegram) VALUES
        ROW(
            \"#{parseNil(student_data[:last_name])}\",
            \"#{parseNil(student_data[:first_name])}\",
            \"#{parseNil(student_data[:parental_name])}\",
            \"#{parseNil(student_data[:git])}\",
            \"#{parseNil(student_data[:phone])}\",
            \"#{parseNil(student_data[:email])}\",
            \"#{parseNil(student_data[:telegram])}\"
        )
        """)
  end

  def replace_by_id(id, student_data)
    self.remove_by_id(id)
    self.add_student(student_data.to_hash)
  end

  def get_students_pag(k, n, existing_data = nil)
    rows = db_connection.query("SELECT * FROM student ORDER BY id LIMIT #{n} OFFSET #{(k-1)*n}")
    data_list = DataListStudentShort.new
    rows.each do |row|
      row_sym = row.transform_keys{|key| key.to_sym}
      data_list.append(StudentShort.from_student_class(Student.from_hash(row_sym)))
    end
    return data_list if existing_data.nil?
    existing_data.replace_objects(data_list.objects)
    existing_data
  end

  def count
    result = db_connection.query("SELECT count(*) FROM student")
    result.first.values.first
  end

end

students_db = StudentDB.new
students_db.insert_data