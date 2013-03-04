module Paloma
  #
  # rails g paloma:setup
  #   - Generates the following:
  #     - index.js and paloma.js under the 'paloma' folder
  #
  # Generated Files:
  # index.js
  #   - contains code for requiring all callbacks of all folders
  #   - always updated when new folders and callback.js files are created
  #
  # paloma.js
  #   - declaration of namespace used in all callbacks
  #

  class SetupGenerator < ::Rails::Generators::Base
    source_root Paloma.templates
    
    def setup_paloma
      locals_js = "#{Paloma.destination}/_locals.js"
      filters_js = "#{Paloma.destination}/_filters.js"
      index_js = "#{Paloma.destination}/index.js"
   
      copy_file '/application/_locals.js', locals_js unless File.exists?(locals_js)   
      copy_file 'index.js', index_js unless File.exists?(index_js)
      
      unless File.exists?(filters_js)
        content = File.read("#{Paloma.templates}/_filters.js")
        content.gsub!(':scope', '/')

        File.open(filters_js, 'w'){ |f| f.write(content) }
        puts "create #{filters_js}"
      end
    end
  end
end
