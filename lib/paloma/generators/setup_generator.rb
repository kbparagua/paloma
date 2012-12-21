module Paloma
  #
  # rails g paloma:setup
  #   - Generates the following:
  #     - 'paloma' folder under app/assets/javascripts/
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
      index_js = "#{Paloma.destination}/index.js"
      paloma_js = "#{Paloma.destination}/paloma.js"
      
      copy_file 'index.js', index_js unless File.exists?(index_js)
      copy_file 'paloma.js', paloma_js unless File.exists?(paloma_js)
    end
  end
end
