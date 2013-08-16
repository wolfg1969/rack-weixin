$:.push File.expand_path("../lib", __FILE__)  
require "weixin/version"

Gem::Specification.new do |s|

    s.name = 'rack-weixin'
    s.version = Weixin::VERSION 

    s.description = 'Rack middleware for Weixin apps: message validation/parser/generator'
    s.summary = 'Rack middleware for Weixin apps'

    s.authors = ['wolfg1969']
    s.email = 'wolfg1969@gmail.com'

    s.files = `git ls-files`.split("\n")
    s.test_files = s.files.select {|path| path =~ /^spec\/.*_spec\.rb/}

    s.add_dependency 'rack'
    s.add_dependency 'multi_json', '>= 1.7.9'
    s.add_dependency 'multi_xml', '>= 0.5.2'
    s.add_dependency 'roxml'
    s.add_dependency 'nestful'

    s.add_development_dependency 'rake'
    s.add_development_dependency 'rack-test'
    s.add_development_dependency 'rspec', '>= 2.0.0'

    s.homepage = 'https://github.com/wolfg1969/rack-weixin'
    s.require_paths = %w[lib]
end