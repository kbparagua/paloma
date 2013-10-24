Gem::Specification.new do |s|
  s.name        = 'paloma'
  s.version     = '3.0.0'
  s.summary     = "Provides an easy way to execute page-specific javascript for Rails."
  s.description = "Page-specific javascript for Rails done right"
  s.authors     = ['Karl Paragua']
  s.email       = 'kb.paragua@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/kbparagua/paloma'

  s.add_dependency 'jquery-rails'

  s.add_development_dependency 'rails', ['~> 3.2.0']
  s.add_development_dependency 'rake', ['>= 0']
  s.add_development_dependency 'rspec', ['>= 0']
  s.add_development_dependency 'rspec-rails', ['~> 2.0']
  s.add_development_dependency 'capybara', ['~> 1.0']
  s.add_development_dependency 'jasmine-rails', ['~> 0.4.5']
end
