Gem::Specification.new do |s|
  s.name              = 'up'
  s.version           = '0.0.1'
  s.platform          = Gem::Platform::RUBY
  s.authors           = [ 'Samer Abdel-Hafez' ]
  s.email             = %w( sam@arahant.net )
  s.homepage          = 'http://github.com/nopedial/up'
  s.summary           = 'Up'
  s.description       = 'File uploader'
  s.rubyforge_project = s.name
  s.files             = `git ls-files`.split("\n")
  s.executables       = %w( upd )
  s.require_path      = 'lib'

  s.add_dependency 'json', '~> 2.0', '>= 2.0.2'
  s.add_dependency 'sinatra', '~> 1.4', '>= 1.4.7'
  s.add_dependency 'thin', '~> 1.6', '>= 1.6.4'
  s.add_dependency 'logger', '~> 1.2', '>= 1.2.8'
  s.add_dependency 'asetus', '~> 0.3', '>= 0.3.0'
end
