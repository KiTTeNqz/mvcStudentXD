class DataTable

	attr_accessor :data

	def initialize(data)
		self.data = data
	end

	def get_cell(row,col)
		self.data[row][col]
	end

	def num_columns
		self.data[0].length
	end

	def num_rows
		self.data.length
	end

	def to_2d_array
		data.dup
	end

end