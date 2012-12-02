#!/usr/bin/ruby1.9.1

lib = File.expand_path('../../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rubygems'
require 'ruby-3df'

begin

  f = Ruby3DF::File.new( '/data/projects/regions/map2' )
  f.set_size( [-512,512], [-512,512], 256 )
  f.set_payload Ruby3DF::UInt8Bit.new

  f.set_pos( 10, 5, 10)
  f.value 10
  f.value_at( [20, 5, 10], 11 )
  f.value_at( [-10, -5, 10], 12 )

  f.value_at( [10, 5, 10] )
  f.value_at( [20, 5, 10] )
  f.value_at( [-10, -5, 10] )

  f.close

rescue => e
  puts e.message
end
