require 'json'
class StudentBase
	private_class_method :new

	def self.validate_phone?(phone)
		return phone.match(/^\+?[7,8] ?\(?\d{3}\)? ?\d{3}-?\d{2}-?\d{2}$/)
	end

	def self.validate_email?(email)
		return email.match(/^[A-Za-z0-9\-_]+@[A-Za-z]+(\.[A-Za-z]+)?\.[A-Za-z]+$/)
	end

	def self.validate_git_tg?(acc_name)
		return acc_name.match(/^@[A-Za-z0-9\-_]+$/)
	end

	def self.validate_name?(prof_name)
		return prof_name.match(/(^[А-Я][а-я]+$)|(^[A-Z][a-z]+$)/)
	end

	def valid_cont?
		!email.nil? || !telegram.nil? || !phone.nil?
	end

	def validate?
		!git.nil? && valid_cont?
	end

	def initialize(last_name, first_name, parental_name)
		self.last_name = last_name
		self.first_name = first_name
		self.parental_name = parental_name
	end

	def first_name=(first_name1)
		raise ArgumentError, "ERROR first_name=#{first_name1}" unless StudentBase.validate_name?(first_name1)
		@first_name=first_name1
	end

	def last_name=(last_name1)
		raise ArgumentError, "ERROR last_name=#{last_name1}" unless StudentBase.validate_name?(last_name1)
		@last_name=last_name1
	end

	def parental_name=(parental_name1)
		raise ArgumentError, "ERROR parental_name=#{parental_name1}" unless StudentBase.validate_name?(parental_name1)
		@parental_name=parental_name1
	end

end