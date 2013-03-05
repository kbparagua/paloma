require 'rails/generators/named_base'
require 'rails/generators/rails/controller/controller_generator'
require 'fileutils'
require 'generator_spec/test_case'


TEMP = "#{File.dirname(__FILE__)}/tmp/"


def mimic_setup
  # Mimic SetupGenerator results before running the AddGenerator
  FileUtils.cd TEMP
  FileUtils.mkpath Paloma.destination
  File.open("#{Paloma.destination}/index.js", 'w') { 
    |f| f.write('//= require ./paloma_core.js')
  }
end
