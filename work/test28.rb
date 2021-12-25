#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+"/../lib")
require "sgl"

def setup
  window 100, 100
end

def display
  line 0, 0, 100, 100
end
