#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+"/../lib")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'cutep'
require 'autoreload'
autoreload(:interval=>1, :verbose=>true, :reprime=>true) do
  require "sgl"
  require "test27"
end

if ARGV[0] == "--test"
  ARGV.shift
  require "test/unit"
  class TestIt < Test::Unit::TestCase
    def test_it
      assert_equal(2, 1+1)
      #it = SGLApp.new
    end
  end
else
#  SGLApp.new.main(ARGV)
end
