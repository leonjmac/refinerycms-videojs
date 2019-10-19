# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-videojs}
  s.version           = %q{0.5.5.16}
  s.summary           = %q{Videos extension for Refinery CMS}
  s.description       = %q{Manage videos in RefineryCMS. Use HTML5 Video.js player.}
  s.email             = %q{amishchuk@adexin.com}
  s.homepage          = %q{http://www.adexin.com}
  s.rubyforge_project = %q{refinerycms-videojs}
  s.authors           = ['Anton Mishchuk']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"]

  s.add_dependency 'rack-cache'
  s.add_dependency 'refinerycms-core'
  s.add_dependency 'refinerycms-dragonfly', '>= 1.0'
  s.add_dependency 'refinerycms-wymeditor', '>= 1.1.0'
end
