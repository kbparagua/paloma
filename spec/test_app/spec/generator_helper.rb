require 'rails/generators/named_base'
require 'rails/generators/rails/controller/controller_generator'
require 'fileutils'
require 'generator_spec/test_case'


TEMP = "#{File.dirname(__FILE__)}/tmp/"

# We override the original Paloma.destination
# so that when run_generator command is executed by the specs
# Paloma.destination will point to /spec/tmp instead of /test_app itself.
$test_destination = "#{TEMP}#{Paloma.destination}"
module Paloma
  def self.destination
    $test_destination
  end
end


def mimic_setup
  # Mimic SetupGenerator results before running the AddGenerator
  FileUtils.cd TEMP
  FileUtils.mkpath Paloma.destination
  File.open("#{Paloma.destination}/index.js", 'w') { 
    |f| f.write('//= require ./paloma_core.js')
  }
end
