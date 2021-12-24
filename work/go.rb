#!/usr/bin/env ruby
# coding: utf-8

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))+"/../lib"
# $LOAD_PATH << "../../sgl/lib"
require 'autoreload'
#require 'stu/autoreload'
autoreload(:interval=>1, :verbose=>true) do
  require "sgl"
  $LOAD_PATH << "."
  require "test8"
end

# $__v__ = Video.instance

$app = SGLApp.new
$app.mainloop
