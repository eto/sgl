# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require "opengl"
include OpenGL
case OpenGL.get_platform
when :OPENGL_PLATFORM_WINDOWS
  OpenGL.load_lib('opengl32.dll', 'C:/Windows/System32')
when :OPENGL_PLATFORM_MACOSX
  OpenGL.load_lib('libGL.dylib', '/System/Library/Frameworks/OpenGL.framework/Libraries')
when :OPENGL_PLATFORM_LINUX
  OpenGL.load_lib()
else
  raise RuntimeError, "Unsupported platform."
end
require 'glu'

require "sdl2"

require "sgl/sgl-color"
require "sgl/opengl-window"
require "sgl/opengl-color"
require "sgl/opengl-event"
require "sgl/opengl-draw"
#require "sgl/sgl-sound"

module SGL
  class Application
    def initialize
      Thread.abort_on_exception = true
      @options = default_options
      initialize_window	# opengl-window.rb
      initialize_color	# opengl-color.rb
      initialize_event	# opengl-event.rb
    end

    def default_options
      {
	:fullscreen=>nil,
	:fov=>45,
	:cursor=>nil,
	:depth=>false,
	:culling=>false,
	:smooth=>false,
	:delaytime=>1.0/60,
	:framerate=>nil,
	:runtime=>nil,
      }
    end
    private :default_options
  end
end
