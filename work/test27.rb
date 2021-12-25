#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

$test_basic_private_methods = private_methods(false)
#p $test_basic_private_methods
#$basic_public_methods = public_methods(false)
require "cutep"
require "autoreload"
#qp private_methods(false)
qp private_methods(false) - $test_basic_private_methods; $test_basic_private_methods = private_methods(false)

$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+"/../lib")
require "sgl"
qp private_methods(false) - $test_basic_private_methods; $test_basic_private_methods = private_methods(false)

def setup
  qp "setup"
  window 100, 100
end

def display
  line 0, 0, 100, 100
end
qp private_methods(false) - $test_basic_private_methods

#p private_methods(false) - basic_private_methods	# [:autoreload, :qp, :display, :setup, :tp]
#qp private_methods(false)
#qp private_methods(false) - $test_basic_private_methods	# [:autoreload, :qp, :display, :setup, :tp]
#qp Object.private_methods(false)
#qp Object.private_methods(false) - $test_basic_private_methods	# [:autoreload, :qp, :display, :setup, :tp]
#p public_methods(false) - basic_public_methods		# []

#mainloop
