# Copyright (c) 2004-2020, Koichiro Eto, All rights reserved.
# See LICENSE

module SGL
  DEFAULT_TYPE = "cocoa"
  #DEFAULT_TYPE = "opengl"
end

unless defined?($sgl_type) && $sgl_type
  $sgl_type = SGL::DEFAULT_TYPE
end

case $sgl_type
when "cocoa"
  require "sgl/cocoa"
#when "opengl"
#  require "sgl/opengl"
#else
  raise "unknown type"
end
