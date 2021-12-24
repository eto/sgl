#!/usr/bin/env ruby
# coding: utf-8

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))+"/../lib"
require 'autoreload'
autoreload(:interval=>1, :verbose=>true) do
  require "sgl"
  $LOAD_PATH << "."
  require "test15"
end

$app = SGLApp.new
$app.main(ARGV)
