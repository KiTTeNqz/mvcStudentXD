require 'json'
require_relative 'Converter'
class ConverterJSON < Converter
	public_class_method :new

	def read_file(file_content)
		JSON.parse(file_content, {symbolize_names: true})
	end

	def write_file(hash_students)
		JSON.pretty_generate(hash_students)
	end

end