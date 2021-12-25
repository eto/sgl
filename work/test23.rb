#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

$LOAD_PATH << "../lib"
require "sgl"
#require "sgl/opengl"

#class App
def setup
  qp "setup"
  window 100, 100
end

def display
  line 0, 0, 100, 100
end
#end

#$app = App.new
#$app.setup
mainloop
