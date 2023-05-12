# frozen_string_literal: true

require_relative "mvcStudentXD/version"

module MvcStudentXD
  Dir[File.dirname(__FILE__) + "source/**/*.rb"].each do |file|
      puts file
      require file
    end
end
