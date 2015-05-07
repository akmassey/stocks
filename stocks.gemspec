Gem::Specification.new do |s|
  s.name        = 'stocks'
  s.version     = '0.0.1'
  s.date        = Date.today
  s.summary     = "Provides a library for analyzing stocks"
  s.description = "A programmatic approach to performing various financial analysis"
  s.authors     = ["Matthew Fornaciari"]
  s.email       = 'mattforni@gmail.com'
  s.files       = Dir[ File.join('lib', '**', '*.rb') ].reject { |p| File.directory? p }
  s.homepage    = 'http://rubygems.org/gems/stocks'
  s.license     = 'MIT'
  s.add_runtime_dependency 'activerecord', '>= 4'
  s.add_runtime_dependency 'activesupport', '>= 4'
  s.add_runtime_dependency 'yahoofinance', '~> 1.2'
  s.add_development_dependency 'rspec', '~> 2'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.post_install_message = 'Now go make yourself some money!'
end

