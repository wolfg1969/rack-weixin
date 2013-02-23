Gem::Specification.new do |s|

    s.name = 'rack-weixin'
    s.version = '0.0.2'

    s.description = 'Rack middleware for Weixin apps: message validation/parser/generator'
    s.summary = 'Rack middleware for Weixin apps'

    s.authors = ['wolfg1969']
    s.email = 'wolfg1969@gmail.com'

    s.files = `git ls-files`.split("\n")
    s.test_files = s.files.select {|path| path =~ /^spec\/.*_spec\.rb/}

    s.add_dependency 'rack', '>= 0.9.1'
    s.add_development_dependency 'rspec', '>= 2.0.1'

    s.homepage = 'https://github.com/wolfg1969/rack-weixin'
    s.require_paths = %w[lib]
end
