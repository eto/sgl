#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

$test_basic_private_methods = private_methods(false)
require "autoreload"
require "cutep"
autoreload(:interval=>1, :verbose=>true, :reprime=>true) {
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__)+"/../lib")
  require "sgl"
}
qp private_methods(false) - $test_basic_private_methods; $test_basic_private_methods = private_methods(false)

def setup
  #window 100, 100
  window 500, 500
end

def display
  #qp "display"
  #line 0, 0, 100, 100
  line 0, 0, 500, 500
  color 100, 100, 0
  rect 100, 200, 300, 400
end
qp private_methods(false) - $test_basic_private_methods
