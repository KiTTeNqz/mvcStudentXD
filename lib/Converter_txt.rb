require_relative 'Converter'
class ConverterTxt < Converter
	public_class_method :new

	def read_file(data)
		result = []
		file_content = data.split("\n")
		file_content.each do |line|
			hash = {}
			puts(line)
			pairs = line.split(',').map{|pair| pair.gsub(/\s+/, '').split(':')}
			pairs.each do |pair|
				hash[pair[0].to_sym]=(pair[0]=="id") ? pair[1].to_i : pair[1]
			end
			result << hash
		end
		result
	end

	def write_file(hash_students)
		string_arr = hash_students.map do |hash|
			hash.map{|k,v| "#{k}:#{v}"}.join(',')
		end.join("\n")
	end

end