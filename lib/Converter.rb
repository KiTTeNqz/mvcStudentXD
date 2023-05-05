class Converter
	private_class_method :new

	def read_file(file_content)
		raise NotImplementedError, 'Abstract class!'
	end

	def write_file(hash_students)
		raise NotImplementedError, 'Abstract class!'
	end
end