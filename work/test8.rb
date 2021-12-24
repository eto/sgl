#!/usr/bin/env ruby
# coding: utf-8

class SGLApp
  def setup
    #window 100,100
    #window 1000,1000
    window 900, 900
  end

  def display
    #p "display"
    line 0, 0, 1000, 1000
    rect 200, 200, 800, 800
  end
end
