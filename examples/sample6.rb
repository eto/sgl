#!/usr/bin/env ruby
# coding: utf-8

$LOAD_PATH << "../lib"
require "sgl"

class App
  def setup
    window 200, 200
  end

  def display
    for a in 0..200
      color a/2, 50, 50
      if a < 100
        line a, 50, a, 100
      else
        line a, 100, a, 150
      end
    end
  end
end

$app = App.new
$app.setup
mainloop
