#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'


RSpec::Core::RakeTask.new('test') do |t|
  t.rspec_opts = '-c --fail-fast'
end

task :default => [:test, :build]
