require 'bundler/gem_tasks'
require 'rake/testtask'

desc 'Run all the tests'
task :default => [:test]

desc "Run all the tests"
task :test do
    sh "rspec -Ilib/*:spec spec"
end

