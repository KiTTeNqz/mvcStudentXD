require 'yaml'
require_relative 'Converter'
class ConverterYAML < Converter
	public_class_method :new
	
	def read_file(file_content)
		YAML.safe_load(file_content).map{ |h| h.transform_keys(&:to_sym)}
	end

	def write_file(hash_students)
		YAML.dump(hash_students.map{ |h| h.transform_keys(&:to_s)})
	end

end
