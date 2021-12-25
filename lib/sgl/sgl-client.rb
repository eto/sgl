#!/usr/bin/env ruby -w
# coding: utf-8
# Copyright (C) 2004-2021 Koichiro Eto, All rights reserved.
# License: BSD 3-Clause License

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/sgl-connect"

module Sgl
  class Client
    def self.main(argv)
      uri = ARGV.shift
      there = DRbObject.new_with_uri(uri)
      there.puts('Hello, World.')
    end
  end
end

if $0 == __FILE__
  require "test/unit"
  Sgl::Client.main(ARGV)
end
