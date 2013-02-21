Gem::Specification.new do |s|
    s.specification_version = 2 if s.respond_to? :specification_version=
    s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

    s.name = 'rack-weixin'
    s.version = '0.0.1'

    s.description = 'Rack middleware for Weixin apps'
    s.summary = 'Rack middleware for Weixin apps'

    s.authors = ['wolfg1969']
    s.email = 'wolfg1969@gmail.com'

    s.files = %w[
        Rakefile
        lib/weixin.rb
        spec/weixin_spec.rb
    ]

    s.test_files = s.files.select {|path| path =~ /^spec\/.*_spec\.rb/}

    s.add_dependency 'rack', '>= 0.9.1'
    s.add_development_dependency 'rspec', '>= 2.0.1'

    s.homepage = 'https://github.com/wolfg1969/rack-weixin'
    s.require_paths = %w[lib]
    s.rubygems_version = '1.1.1'
end
