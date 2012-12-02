# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'ruby-3df'

Gem::Specification.new do |s|
  s.summary = "3D File"
  s.description = "Organise data in a binary file based on 3D (x, z, y) ordering"
  s.name = "ruby-3df"
  s.author = "Dave Avent"
  s.email =  "davent@lumux.co.uk"
  s.homepage = "http://3df.lumux.co.uk/"
  s.version = Ruby3DF::VERSION
  s.files = Dir["share/*.rb"] + Dir["test/*.rb"] + Dir["lib/**/*.rb"]
end
