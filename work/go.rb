#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8
#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+"/../lib")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'cutep'
#pp $LOAD_PATH
require 'autoreload'
#pp $"
autoreload(:interval=>1, :verbose=>true, :reprime=>true) do
  require "sgl"
  require "test15"
end

if ARGV[0] == "--test"
  ARGV.shift
  require "test/unit"
  class TestIt < Test::Unit::TestCase
    def test_it
      assert_equal(2, 1+1)
      #it = SGLApp.new
    end
  end
else
  SGLApp.new.main(ARGV)
  #$app = SGLApp.new
  #$app.main(ARGV)
end
