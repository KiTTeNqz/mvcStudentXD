class DataList
	private_class_method :new

	attr_accessor :selected_num, :objects

	def initialize(*elems)
		self.objects = elems
		@listeners = []
	end

	def add_listener(listener)
		@listeners << listener
	end

	def remove_listener(listener)
		@listeners.delete(listener)
	end

	def notify
		@listeners.each { |lst| lst.on_datalist_changed(data_table) }
	end

	def select_element(number)
		self.selected_num = number < objects.size ? number : nil
	end

	def selected_id
		objects[selected_num].id
	end

	def get_names
		self.objects.first.instance_variables.map{|v| v.to_s[1..-1]}
	end

	def table_fields(_obj)
		[]
	end

	def data_table
		result = []
		counter = 0
		objects.each do |obj|
			row = []
			row << counter
			row.push(*table_fields(obj))
			result << row
			counter += 1
		end
		DataTable.new(result)
	end

	def append(new_data)
		self.objects.append(new_data)
	end

	def replace_objects(objects)
		self.objects = objects.dup
		notify
	end

	private
	def instance_variables_wout_id(object)
		object.instance_variables.reject{|v| v.to_sym ==:@id}.map{|v| object.instance_variable_get(v)}
	end

end