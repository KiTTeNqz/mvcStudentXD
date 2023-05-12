class StudentList
  private
	attr_accessor :students, :gen_id, :typer

  public
	def initialize(typer)
		self.students = []
		self.gen_id = students.count + 1
		self.typer = typer
	end

	def read_file(file_path)
		raise ArgumentError.new("File not found #{file_path}") unless File.file?(file_path)
		hash_students = typer.read_file(File.read(file_path))
		self.students = hash_students.map{|h| Student.from_hash(h)}
		nextId
	end

	def write_file(file_path)
		hash_students = students.map(&:to_hash)
		File.write(file_path, typer.write_file(hash_students))
	end

	def get_student(stud_id)
		students.find{|s| s.id == stud_id}
	end

	def sorted
		students.sort_by(&:fio)
	end

	def add_student(student)
		students << student
		student.id = gen_id
		nextId
	end

	def get_students_pag(k,n,existing_data = nil)
		skip = (k-1) * n
		new_data = students[skip, n].map{|s| StudentShort.from_student_class(s)}

		return DataListStudentShort.new(new_data) if existing_data.nil?

		existing_data.replace_objects(new_data)
		existing_data
	end

	def replace_student(student_id, student)
		idx = student.find{|s| s.id==student.id}
		self.students[idx]=student
	end

	def remove_student(student_id)
		self.students.reject! {|s| s.id==student_id}
	end

  def count
		self.students.count
	end

	def nextId
		self.gen_id=students.max_by(&:id).id + 1
	end

end