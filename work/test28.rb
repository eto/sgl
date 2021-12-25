#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

$test_basic_private_methods = private_methods(false)
require "cutep"
require "autoreload"

$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+"/../lib")
require "sgl"
qp private_methods(false) - $test_basic_private_methods; $test_basic_private_methods = private_methods(false)

def setup
  window 100, 100
end

def display
  line 0, 0, 100, 100
end
qp private_methods(false) - $test_basic_private_methods
