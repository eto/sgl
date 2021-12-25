#!/usr/local/opt/ruby/bin/ruby
# coding: utf-8

basic_private_methods = private_methods(false)
p basic_private_methods
basic_public_methods = public_methods(false)
#p basic_public_methods

private def explicit_private_method
end

# トップレベルで定義したメソッドは main オブジェクトの private メソッドと して定義される
def implicit_private_method
end

public def explicit_public_method
end

# main オブジェクトで独自定義した private method のみを取得する
p private_methods(false)
p private_methods(false) - basic_private_methods
# => [:explicit_private_method, :implicit_private_method]

# main オブジェクトで独自定義した public method のみを取得する
#p public_methods(false)
#p public_methods(false) - basic_public_methods
# => [:explicit_public_method]
