Gem::Specification.new do |s|
  s.name        = 'paloma'
  s.version     = '0.0.5'
  s.summary     = "a sexy way to organize javascript files using Rails` asset pipeline"
  s.description = "a sexy way to organize javascript files using Rails` asset pipeline"
  s.authors     = ["Karl Paragua", "Bia Esmero"]
  s.email       = 'kb.paragua@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/kbparagua/paloma'
  
  s.add_dependency 'jquery-rails'
  
  s.add_development_dependency 'rails', ['>= 3.1.0']
  s.add_development_dependency 'bundler', ['>= 1.0.0']
  s.add_development_dependency 'rake', ['>= 0']
  s.add_development_dependency 'sqlite3', ['>= 0']
  s.add_development_dependency 'rspec', ['>= 0']
  s.add_development_dependency 'rspec-rails', ['~> 2.0']
  s.add_development_dependency 'capybara', ['>= 1.0']
  s.add_development_dependency 'database_cleaner', ['>= 0']
  s.add_development_dependency 'launchy', ['>= 0']
end
