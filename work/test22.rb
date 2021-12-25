#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

basic_private_methods = private_methods(false)
basic_public_methods = public_methods(false)

private def explicit_private_method
  puts "explicit_private_method"
end

def implicit_private_method
  puts "implicit_private_method"
end

public def explicit_public_method
  puts "explicit_public_method"
end

p private_methods(false) - basic_private_methods	# => [:explicit_private_method, :implicit_private_method]
#p public_methods(false) - basic_public_methods	# => [:explicit_public_method]

class SomeClass
  private def explicit_private_method
    puts "SomeClass.explicit_private_method"
  end

  def implicit_private_method
    puts "SomeClass.implicit_private_method"
  end

  public def explicit_public_method
    puts "SomeClass.explicit_public_method"
  end

  def main
    explicit_private_method
    implicit_private_method
    explicit_public_method
    #Object.explicit_private_method
    #Object.implicit_private_method	# これを呼び出したい。
    Object.explicit_public_method
  end
end
it = SomeClass.new
it.main
