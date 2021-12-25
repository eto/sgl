#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

$basic_private_methods = private_methods(false)

def implicit_private_method
  puts "implicit_private_method"
end

p private_methods(false) - $basic_private_methods	# => [:explicit_private_method, :implicit_private_method]

class SomeClass
  def implicit_private_method
    puts "SomeClass.implicit_private_method"
  end

  def main
    implicit_private_method
    #Object.implicit_private_method	# これを呼び出したい。
    Object.send(:implicit_private_method)
    #if Object.respond_to?(:implicit_private_method)
    #p private_methods(true)
    p private_methods(false) - $basic_private_methods
    p respond_to?(:implicit_private_method)
    #p Object.private_methods(false) - $basic_private_methods
    #p Kernel.private_methods(false) - $basic_private_methods
    #if Kernel.respond_to?(:implicit_private_method)
    if respond_to?(:implicit_private_method)
      p true
      #Object.send(:implicit_private_method)
    end
  end
end
it = SomeClass.new
it.main
