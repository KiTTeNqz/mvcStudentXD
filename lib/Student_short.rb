require_relative 'StudentBase'
class StudentShort < StudentBase

	public_class_method :new

	#У нас уже есть некоторые гет\сет в базе, зачем же ещё?
	private
	attr_writer :fio, :contact, :git, :id

	public
	attr_reader :fio, :contact, :git, :id

	def self.from_student_class(student)
		puts("In studentShort: #{student.to_s}")
		StudentShort.new(student.id, student.get_info)
	end

	def initialize(id, str)
		info_short = str.split(',')
						.map{|x| x.split(':')}
						.map{|x| [x[0].to_sym, x[1]]}
						.to_h
		raise ArgumentError, 'Missing fields: fio' if info_short[:fio].nil?
		print(info_short)
		self.id=id
		self.fio = info_short[:fio]
		self.git = info_short[:git]
		info_short.delete_if{|k,v| k==:fio||k==:git}
		self.contact = info_short.values.first
	end


	def to_s

		[
			"#{id}, #{fio}, #{git}, #{contact}"
		].compact.join(' ')
	end
	
end
