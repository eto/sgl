#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

m1 = Object.instance_methods.dup
p m1
def setup
  "setup"
end
p Object.instance_methods.grep(/setup/)
m2 = Object.instance_methods.dup
p m2
p m2 - m1
