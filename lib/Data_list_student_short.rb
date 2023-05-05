require_relative 'Student_short'
require_relative 'Data_table'
require_relative 'Data_list'
class  DataListStudentShort < DataList

	public_class_method :new

	def get_names
		['Фамилия И.О.','Гит','Контакт']
	end


	def table_fields(obj)
		[obj.fio, obj.git, obj.contact]
	end

end