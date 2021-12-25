#!/usr/bin/env ruby -w
# coding: utf-8
# Copyright (C) 2004-2021 Koichiro Eto, All rights reserved.
# License: BSD 3-Clause License

#require "sgl/opengl-app"

$basic_private_methods = private_methods(false)
$basic_public_methods = public_methods(false)

require "opengl"
#include OpenGL
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

#p private_methods(false) - $basic_private_methods

#require "gl"
require "glu"
GLU.load_lib()
#require "glut"
#require "mathn"
#include Gl
#include GLU
#include Glut

#p private_methods(false) - $basic_private_methods

require "sdl2"

require "sgl/sgl-color"
#require "sgl/opengl-window"
#require "sgl/opengl-color"
#require "sgl/opengl-event"
#require "sgl/opengl-draw"
#require "sgl/sgl-sound"

#p private_methods(false) - $basic_private_methods

at_exit {
  mainloop
}

module SGL
  # window functions
  def window(*a)	$__a__.window(*a)	end
  def close_window()	$__a__.close_window;	end
  def width()	$__a__.width;	end
  def height()	$__a__.height;	end

  # opengl special functions
  def useFov(*a)	$__a__.useFov(*a);	end
  def useDepth(*a)	$__a__.useDepth(*a)	end
  def useSmooth(*a)	$__a__.useSmooth(*a)	end
  def useCulling(*a)	$__a__.useCulling(*a)	end
  def useFullscreen(*a)	$__a__.useFullscreen(*a)	end
  alias useFullScreen useFullscreen
  def useCursor(*a)	$__a__.useCursor(*a)	end

  # ====================================================================== from opengl-color.rb
  def background(*a)	$__a__.background(*a)	end
  def backgroundHSV(*a)	$__a__.backgroundHSV(*a)	end
  def color(*a)		$__a__.color(*a)	end
  def colorHSV(*a)	$__a__.colorHSV(*a)	end

  # ====================================================================== from opengl-event.rb
  # callback functions
  #def setup()		end
  #def onMouseDown(x,y)	end
  #def onMouseUp(x,y)	end
  #def onKeyDown(k)	end
  #def onKeyUp(k)	end
  #def display()		end

  # callback functions for fullscreen
  #def onMouseDown0(x,y)	end
  #def display0()	end

  # mainloop
  def mainloop
    #p private_methods(false) - $basic_private_methods	[:setup, :display]
    #qp private_methods(false) - $test_basic_private_methods
    qp "setup start at mainloop."
    #    $__a__.set_setup { setup }
    #    p "setup done at mainloop."
    #    $__a__.set_mousedown {|x, y| onMouseDown(x, y) }
    #    $__a__.set_mouseup   {|x, y| onMouseUp(x, y) }
    #    $__a__.set_keydown   {|k| onKeyDown(k) }
    #    $__a__.set_keyup     {|k| onKeyUp(k) }
    #    if ! $__a__.check_display0
    #      $__a__.set_display0 { display0 }
    #      $__a__.set_mousedown0 {|x, y| onMouseDown0(x, y) }
    #    end
    #    $__a__.set_display { display }

    if ! defined?($__sgl_in_mainloop__)
      $__sgl_in_mainloop__ = true
      qp private_methods(false) - $test_basic_private_methods
      #qp Object.private_methods(false) - $test_basic_private_methods
      #$__a__.mainloop
      #qp private_methods(false) - $test_basic_private_methods
      #qp Object.private_methods(false) - $test_basic_private_methods
      #qp $basic_private_methods
      #qp Object.private_methods(false)
      #qp Object.private_methods(false) - $basic_private_methods
      #qp private_methods(false) - $basic_private_methods

      #$__a__.mainloop_setup
      @starttime = Time.now
      loop {
        p "loop of mainloop."
	@begintime = Time.now
	#$__a__.do_display
        #def do_display # callback
        #p "do_display"
        #return if @setup_done.nil?
        #return if @display_drawing
        @display_drawing = true
        $__a__.display_pre
        #p "display_pre done"
        #@block[:display].call if @block[:display]
        #      if $app && $app.respond_to?(:display)
        #        #p "$app.display"
        #        $app.display
        #      end
        send(:display) if respond_to?(:display)
        display
        $__a__.display_post
        #@display_drawing = nil
        #end
	$__a__.delay
	return if $__a__.check_runtime_finished(@starttime)
      }

    else
      # do setup only.
      #$__a__.mainloop_setup
      #def mainloop_setup
      do_setup
      #end

      # for debug
      # $__a__.mainloop
    end
  end

  # novice mode
  #def flip(*a)	$__a__.flip(*a)	end
  #def wait(*a)	$__a__.wait(*a)	end
  #def process(&b)	$__a__.process(&b)	end

  # get status functions
  def mouseX()	$__a__.mouseX;	end
  def mouseY()	$__a__.mouseY;	end
  def mouseDown()	$__a__.mouseDown;	end
  def key(k)	$__a__.key[k];	end
  def keynum()	$__a__.keynum;	end

  # get status functions for fullscreen
  def mouseX0()	$__a__.mouseX0;	end
  def mouseY0()	$__a__.mouseY0;	end

  # event control
  def useDelay(*a)	$__a__.useDelay(*a)	end
  def useFramerate(*a)	$__a__.useFramerate(*a)	end
  def useRuntime(*a)	$__a__.useRuntime(*a)	end

  #====================================================================== from opengl-draw.rb
  LINES		= OpenGL::GL_LINES
  POINTS	= OpenGL::GL_POINTS
  LINE_STRIP	= OpenGL::GL_LINE_STRIP
  LINE_LOOP	= OpenGL::GL_LINE_LOOP
  TRIANGLES	= OpenGL::GL_TRIANGLES
  TRIANGLE_STRIP	= OpenGL::GL_TRIANGLE_STRIP
  TRIANGLE_FAN	= OpenGL::GL_TRIANGLE_FAN
  QUADS		= OpenGL::GL_QUADS
  QUAD_STRIP	= OpenGL::GL_QUAD_STRIP
  POLYGON	= OpenGL::GL_POLYGON

  # draw
  def beginObj(*a)	$__a__.beginObj(*a)	end
  def endObj(*a)	$__a__.endObj(*a)	end
  def push(*a)		$__a__.push(*a)		end
  def pop(*a)		$__a__.pop(*a)		end
  def vertex(*a)	$__a__.vertex(*a)	end
  def normal(*a)	$__a__.normal(*a)	end
  def translate(*a)	$__a__.translate(*a)	end
  def rotateX(*a)	$__a__.rotateX(*a)	end
  def rotateY(*a)	$__a__.rotateY(*a)	end
  def rotateZ(*a)	$__a__.rotateZ(*a)	end
  def scale(*a)		$__a__.scale(*a)	end
  def point(*a)		$__a__.point(*a)	end
  def lineWidth(*a)	$__a__.lineWidth(*a)	end
  def line(*a)		$__a__.line(*a)		end
  def rect(*a)		$__a__.rect(*a)		end
  def triangle(*a)	$__a__.triangle(*a)	end
  def circle(*a)	$__a__.circle(*a)	end
  def box(*a)		$__a__.box(*a)		end
  def cube(*a)		$__a__.cube(*a)		end

  # ====================================================================== opengl-app.rb
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

    #====================================================================== from opengl-window.rb
    DEFAULT_WINDOW_WIDTH  = 100
    DEFAULT_WINDOW_HEIGHT = 100
    DEFAULT_FULLSCREEN_WIDTH  = 1024
    DEFAULT_FULLSCREEN_HEIGHT = 768

    def initialize_window
      @width, @height = DEFAULT_WINDOW_WIDTH, DEFAULT_WINDOW_HEIGHT
      @left, @bottom, @right, @top = 0, 0, @width, @height
      @cameraX, @cameraY, @cameraZ = 0, 0, 5
      initialize_sdl
      @window_initialized = true
    end

    def initialize_sdl
      SDL2.init(SDL2::INIT_EVERYTHING)
      # Setting color size is important for Mac OS X.
=begin
      SDL2::GL.set_attribute(SDL2::GL::RED_SIZE, 5)
      SDL2::GL.set_attribute(SDL2::GL::GREEN_SIZE, 5)
      SDL2::GL.set_attribute(SDL2::GL::BLUE_SIZE, 5)
      SDL2::GL.set_attribute(SDL2::GL::DEPTH_SIZE, 16)
      SDL2::GL.set_attribute(SDL2::GL::DOUBLEBUFFER, 1)
=end
      SDL2::GL.set_attribute(SDL2::GL::RED_SIZE, 8)
      SDL2::GL.set_attribute(SDL2::GL::GREEN_SIZE, 8)
      SDL2::GL.set_attribute(SDL2::GL::BLUE_SIZE, 8)
      SDL2::GL.set_attribute(SDL2::GL::ALPHA_SIZE, 8)
      SDL2::GL.set_attribute(SDL2::GL::DOUBLEBUFFER, 1)
#      if !windows?
#	SDL2.setVideoMode(640, 400, 16, SDL2::OPENGL)
#      end
#      @sdl_event = SDL2::Event.new
      @sdl_event = nil
    end
    private :initialize_window, :initialize_sdl

    def windows?
      r = RUBY_PLATFORM
      (r.index("cygwin") || r.index("mswin32") || r.index("mingw32")) != nil
    end
    private :windows?

    # create window
    def window(*a)
      @options.update(a.pop) if a.last.is_a? Hash

      if a.length == 4
	@left, @bottom, @right, @top = a
      elsif a.length == 2
	@right, @top = a
	@left = @bottom = 0
      else
	raise "error"
      end

      @width, @height = (@right - @left), (@top - @bottom)

      # Do not initialize twice.
      if ! defined?($__sgl_sdl_window_initialized__)
        # sdl_window_init
=begin
        mode =  SDL2::OPENGL
        if @options[:fullscreen]
          mode |= SDL2::FULLSCREEN
          w, h = @options[:fullscreen]
          SDL2.setVideoMode(w, h, 0, mode)
        else
          SDL2.setVideoMode(@width, @height + 1, 0, mode) # why +1?
        end
        GC.start
        SDL2::WM.setCaption("sgl", "sgl")
=end
        @sdl_window = SDL2::Window.create("sgl", 0, 0, @width, @height + 1, SDL2::Window::Flags::OPENGL)
        #p @sdl_window
        sdl_context = SDL2::GL::Context.create(@sdl_window)
#        printf("OpenGL version %d.%d\n",
#               SDL2::GL.get_attribute(SDL2::GL::CONTEXT_MAJOR_VERSION),
#               SDL2::GL.get_attribute(SDL2::GL::CONTEXT_MINOR_VERSION))
        $__sgl_sdl_window_initialized__ = true
      end

      # setCurosr
      if @options[:cursor]
	# You can use only black and white for cursor image.
	file = @options[:cursor]
	#bmp = SDL2::Surface.loadBMP(file) # Create surface from bitmap.
	bmp = SDL2::Surface.load_bmp(file) # Create surface from bitmap.
#	SDL2::Mouse.setCursor(bmp,		# bitmap
#			     [255, 255, 255],	# white
#			     [  0,   0,   0],	# black
#			     [128, 128, 128],	# transparent
#			     [100, 100, 100],	# inverted
#			     8, 8)		# hot_x, hot_y
      end

      # gl_init
      if @options[:fullscreen]
	set_fullscreen_position
      else
	set_window_position
      end
      set_camera_position
      OpenGL.glEnable(OpenGL::GL_BLEND)
      OpenGL.glBlendFunc(OpenGL::GL_SRC_ALPHA, OpenGL::GL_ONE_MINUS_SRC_ALPHA)
      OpenGL.glShadeModel(OpenGL::GL_SMOOTH)
      useDepth(@options[:depth])
      useCulling(@options[:culling])
      useSmooth(@options[:smooth])

      background(0)
      color(100)

      check_event
    end

    def close_window
      # do nothing for now
    end

    # get window size
    attr_reader :width, :height

    # world control methods
    def useFov(f = 45)
      @options[:fov] = f
    end

    def useDepth(a = true)
      @options[:depth] = a
      @options[:depth] ? OpenGL.glEnable(OpenGL::GL_DEPTH_TEST) : OpenGL.glDisable(OpenGL::GL_DEPTH_TEST)
    end

    def useSmooth(a = true)
      @options[:smooth] = a
      #@options[:smooth] ? OpenGL.glEnable(OpenGL::GL_LINE_SMOOTH) : OpenGL.glDisable(OpenGL::GL_LINE_SMOOTH)
    end

    def useCulling(a = true)
      @options[:culling] = a
      @options[:culling] ? OpenGL.glEnable(OpenGL::GL_CULL_FACE) : OpenGL.glDisable(OpenGL::GL_CULL_FACE)
    end

    def useFullscreen(w=DEFAULT_FULLSCREEN_WIDTH, h=DEFAULT_FULLSCREEN_HEIGHT)
      if @options[:fullscreen].nil?
        @options[:fullscreen] = (w.nil? || h.nil?) ? nil : [w, h]
      end
    end

    def useCursor(bmpfile)
      @options[:cursor] = bmpfile
    end

    def useDelay(sec)
      @options[:delaytime] = sec
    end

    def useFramerate(f)
      @options[:framerate] = f
    end

    def useRuntime(r)
      @options[:runtime] = r
    end

    def runtime=(r)
      useRuntime(r)
    end

    def set_window_position
      @cameraX, @cameraY = ((@left + @right)/2), ((@bottom + @top)/2)
      fov = @options[:fov]
      @cameraZ = 1.0 +
	@height / (2.0 * Math.tan(Math::PI * (fov/2.0) / 180.0))
      OpenGL.glViewport(0, 0, @width, @height)
      OpenGL.glMatrixMode(OpenGL::GL_PROJECTION)
      loadIdentity
      #gluPerspective(fov, @width/@height.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
      #pp GLU.methods
      GLU.gluPerspective(fov, @width/@height.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
    end

    def set_fullscreen_position
      cx, cy = ((@left + @right)/2), ((@bottom + @top)/2)
      @cameraX, @cameraY = cx, cy
      w, h = @options[:fullscreen]
      fhw = w / 2 #fullscreen half width
      fhh = h / 2 #fullscreen half height
      left   = cx - fhw
      bottom = cy - fhh
      right  = cx + fhw
      top    = cy + fhh
      OpenGL.glViewport(0, 0, w, h)
      OpenGL.glMatrixMode(OpenGL::GL_PROJECTION)
      loadIdentity
      fov = @options[:fov]
      @cameraZ = 1.0 + h / (2.0 * Math.tan(Math::PI * (fov/2.0) / 180.0));
      #gluPerspective(fov, w/h.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
      GLU.gluPerspective(fov, w/h.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
    end
    private :set_window_position, :set_fullscreen_position

    def sh(cmd); p cmd; system cmd; end
    def die(msg); puts msg; exit; end

    def set_camera_position
      #pp caller
      #exit
      if ! @window_initialized
        die "Window is not initialized."
      end
      OpenGL.glMatrixMode(OpenGL::GL_PROJECTION)
      #exit
      loadIdentity
      OpenGL.glMatrixMode(OpenGL::GL_MODELVIEW)
      GLU.gluLookAt(@cameraX, @cameraY, @cameraZ,
		 @cameraX, @cameraY, 0,
		 0, 1, 0)
    end

    def set_fullscreen_camera_position
      OpenGL.glMatrixMode(OpenGL::GL_MODELVIEW)
      loadIdentity
      GLU.gluLookAt(0, 0, @cameraZ,
		 0, 0, 0,
		 0, 1, 0)
    end
    private :set_camera_position, :set_fullscreen_camera_position

    def loadIdentity
      OpenGL.glLoadIdentity
    end
    private :loadIdentity

    #====================================================================== from opengl-color.rb
    def initialize_color
      @bg_color = @cur_color = nil
      @rgb = ColorTranslatorRGB.new(100, 100, 100, 100)
      @hsv = ColorTranslatorHSV.new(100, 100, 100, 100)
    end
    private :initialize_color

    attr_reader :cur_color # for test

    def background(x, y = nil, z = nil, a = nil)
      norm = @rgb.norm(x, y, z, a)
      p [x, y, z, a, norm]
      #glClearColor(*norm)
      OpenGL.glClearColor(0.0, 0.1, 0.2, 1.0)
      clear
    end

    def backgroundHSV(x, y = nil, z = nil, a = nil)
      OpenGL.glClearColor(*@hsv.norm(x, y, z, a))
      clear
    end

    def clear
      OpenGL.glClear(OpenGL::GL_COLOR_BUFFER_BIT | OpenGL::GL_DEPTH_BUFFER_BIT)
    end
    private :clear

    def color(x, y = nil, z = nil, a = nil)
      @cur_color = [x, y, z, a]
      OpenGL.glColor4f(*@rgb.norm(x, y, z, a))
    end

    def colorHSV(x, y = nil, z = nil, a = nil)
      OpenGL.glColor4f(*@hsv.norm(x, y, z, a))
    end

    #====================================================================== from opengl-event.rb
    def initialize_event
      @setup_done = nil
      @display_drawing = nil
      @block = {}

      # status setting
      @mouseX, @mouseY = 0, 0
      @mouseX0, @mouseY0 = 0, 0
      @mouseDown = 0
      @keynum = 0

      @starttime = nil
      @window_initialized = false
    end
    private :initialize_event

    # get status
    attr_reader :mouseX, :mouseY
    attr_reader :mouseX0, :mouseY0
    attr_reader :mouseDown
    attr_reader :keynum

    # setup
    def set_setup(&b)
      return unless block_given?
      @block[:setup] = Proc.new { b }
    end

    def setup_pre
      # do nothing
    end

    def do_setup
      setup_pre
      #@block[:setup].call if @block[:setup]
      #$app.setup if $app && $app.respond_to?(:setup)
      qp respond_to?(:setup)
      if respond_to?(:setup)
        send(:setup)
      end
      setup_post
    end

#    def setup_post
#      @setup_done = true
#    end
#    private :setup_pre, :setup_post

    # display
#    def set_display(&b)
#      return unless block_given?
#      @block[:display] = Proc.new { b }
#    end

#    def set_display0(&b)
#      return unless block_given?
#      @block[:display0] = Proc.new { b }
#    end

#    def check_display0
#      return ! @block[:display0].nil?
#    end

    def display_pre
      set_camera_position
      check_event
      clear
    end

    def display_post
      set_fullscreen_camera_position
      cur_color = @cur_color
      #@block[:display0].call if @block[:display0]
      #$app.display_post if $app && $app.respond_to?(:display_post)
      #send(:display0) if respond_to?(:display0)
      color(*cur_color)
      #SDL2.GLSwapBuffers
      #GC.start
    end
    #private :display_pre, :display_post

    # mouse events
#    def set_mousedown(&b)
#      return unless block_given?
#      @block[:mousedown] = Proc.new { b }
#    end

    def do_mousedown
      @mouseDown = 1
      #@block[:mousedown].call(@mouseX, @mouseY) if @block[:mousedown]
      #mouseDown(@mouseX, @mouseY) if defined?(:mousedown)
      #mouseDown if defined?(:mousedown)
      #$app.onMouseDown(@mouseX, @mouseY) if $app && $app.respond_to?(:onMouseDown)
      if respond_to?(:onMouseDown)
        send(:onMouseDown, @mouseX, @mouseY)
      end
      #@block[:mousedown0].call(@mouseX0, @mouseY0) if @block[:mousedown0]
      #mouseDown0(@mouseX, @mouseY)
    end

#    def set_mouseup(&b)
#      return unless block_given?
#      @block[:mouseup] = Proc.new { b }
#    end

    def do_mouseup
      @mouseDown = 0
      @block[:mouseup].call(@mouseX, @mouseY) if @block[:mouseup]
      #$app.onMouseUp(@mouseX, @mouseY) if $app && $app.respond_to?(:onMouseUp)
      if respond_to?(:onMouseUp)
        send(:onMouseUp, @mouseX, @mouseY)
      end
    end

    # mouse events for fullscreen
#    def set_mousedown0(&b)
#      return unless block_given?
#      @block[:mousedown0] = Proc.new { b }
#    end

#    def check_mousedown0
#      return ! @block[:mousedown0].nil?
#    end

    # key events
#    def set_keydown(&b)
#      return unless block_given?
#      @block[:keydown] = Proc.new { b }
#    end

    def keydown_pre(key)
      exit if key == SDL2::Key::ESCAPE
    end
    private :keydown_pre

    def do_keydown(key)
      keydown_pre(key)
      @block[:keydown].call(key) if @block[:keydown]
      #$app.onKeyDown(key) if $app && $app.respond_to?(:onKeyDown)
      if respond_to?(:onKeyDown)
        send(:onKeyDown, key)
      end
    end

#    def set_keyup(&b)
#      return unless block_given?
#      @block[:keyup] = Proc.new { b }
#    end

    def do_keyup(key)
      @block[:keyup].call(key) if @block[:keyup]
      #$app.onKeyUp(key) if $app && $app.respond_to?(:onKeyUp)
      if respond_to?(:onKeyUp)
        send(:onKeyUp, key)
      end
    end

    def calc_keynum(e)
      input = e.characters
      @keynum = input.to_s[0]
    end
    private :calc_keynum

    def delay
      if @options[:framerate]
	sec_per_frame = 1.0 / @options[:framerate]
	diff = sec_per_frame - (Time.now - @begintime)
	sleep(diff) if 0 < diff
      else
	delaytime = @options[:delaytime]
	sleep(delaytime)
      end
    end
#    private :delay

    def check_runtime_finished(starttime)
      runtime = @options[:runtime]
      return false if runtime.nil?
      diff = Time.now - starttime
      return (runtime && runtime < diff)
    end
#    private :check_runtime_finished

    # novice mode
#    def flip
#      @starttime = Time.now if @starttime.nil?
#      display_post
#      delay
#      display_pre
#     #exit if check_runtime_finished(@starttime)
#    end

#    def wait
#      #SGL.flip if !$__v__.flipped
#      loop {
#	check_event
#	delay
#	return if check_runtime_finished(@starttime)
#      }
#    end

#    def process(&b)
#      block = Proc.new { b }
#      @starttime = Time.now
#      loop {
#	check_event
#	block.call
#	#yield
#	delay
#	return if check_runtime_finished(@starttime)
#      }
#    end

    # check event
    #LEFT_MOUSE_BUTTON   = 1
    #MIDDLE_MOUSE_BUTTON = 2
    #RIGHT_MOUSE_BUTTON  = 3
    def check_event
      #x, y, l, m, r = SDL2::Mouse.state
      s = SDL2::Mouse.state
      #p s
      x, y, l, m, r = s.x, s.y, 0, 0, 0
      left_mouse_button   = 1
      middle_mouse_button = 2
      right_mouse_button  = 3
      l = true if s.pressed?(left_mouse_button)
      m = true if s.pressed?(middle_mouse_button)
      r = true if s.pressed?(right_mouse_button)
      #p [x, y, l, m, r]
      # x pos, y pos, left button, middle button, right button
      @mouseX, @mouseY = calc_mouse_xy(x, y)
      @mouseX0, @mouseY0 = calc_fullscreen_mouse_xy(x, y)
      #event = @sdl_event
      while event = SDL2::Event.poll
	case event
	when SDL2::Event::MouseButtonDown
          #p event
	  do_mousedown
	when SDL2::Event::MouseButtonUp
	  do_mouseup
	when SDL2::Event::KeyDown
	  #@keynum = event.info[2]
	  @keynum = event.scancode
	  do_keydown(@keynum)
	when SDL2::Event::KeyUp
	  #@keynum = event.info[2]
	  @keynum = event.scancode
	  do_keyup(@keynum)
	when SDL2::Event::Quit
	  exit
	end
      end
    end

    def calc_mouse_xy(x, y)
      if @options[:fullscreen]
	w, h = @options[:fullscreen]
	mx = @cameraX - (w / 2) + x
	my = @cameraY - (h / 2) + (h - y)
      else
	mx = @left + x
	my = @bottom + (@height - y)
      end
      return [mx, my]
    end

    def calc_fullscreen_mouse_xy(x, y)
      if @options[:fullscreen]
	w, h = @options[:fullscreen]
	mx = - (w / 2) + x
	my = - (h / 2) + (h - y)
      else
	mx = @left + x
	my = @bottom + (@height - y)
      end
      return [mx, my]
    end
    private :check_event, :calc_mouse_xy, :calc_fullscreen_mouse_xy

    #====================================================================== from opengl-draw.rb
    # draw primitive
    def beginObj(mode = POLYGON)
      OpenGL.glBegin(mode)
    end

    def endObj
      OpenGL.glEnd
    end

    def push
      OpenGL.glPushMatrix
    end

    def pop
      OpenGL.glPopMatrix
    end

    def vertex(a, b = nil, c = nil, d = nil)
      OpenGL.glVertex4f(a, b, c, d) if d
      OpenGL.glVertex3f(a, b, c) if c
      OpenGL.glVertex2f(a, b)
    end

    def normal(a, b = nil, c = nil)
      OpenGL.glNormal(a, b, c)
    end

    # matrix manipulation
    def translate(a, b, c = 0)
      #OpenGL.glTranslate(a, b, c)
      OpenGL.glTranslatef(a, b, c)
    end

    def rotateX(a)
      OpenGL.glRotatef(a, 1, 0, 0)
    end

    def rotateY(a)
      OpenGL.glRotatef(a, 0, 1, 0)
    end

    def rotateZ(a)
      OpenGL.glRotatef(a, 0, 0, 1)
    end

    def scale(a)
      OpenGL.glScalef(a, a, a)
    end

    # simple draw
    def point(a, b, c = nil)
      OpenGL.glBegin(OpenGL::GL_POINTS)
      if c
	OpenGL.glVertex3f(a, b, c)
      else
	OpenGL.glVertex2f(a, b)
      end
      OpenGL.glEnd
    end

    def lineWidth(w)
      OpenGL.glLineWidth(w)
    end

    def line(a, b, c, d, e = nil, f = nil)
      #p [a, b, c, d, e, f]
      OpenGL.glBegin(OpenGL::GL_LINES)
      if e && f
	OpenGL.glVertex3f(a, b, c) # 3D
	OpenGL.glVertex3f(d, e, f)
      else
	OpenGL.glVertex2f(a, b) # 2D
	OpenGL.glVertex2f(c, d)
      end
      OpenGL.glEnd
    end

    def rect(a, b, c, d)
      #glRect(a, b, c, d)
      OpenGL.glRectf(a, b, c, d)
    end

    def triangle(a, b, c, d, e, f)
      OpenGL.glBegin(OpenGL::GL_TRIANGLES)
      OpenGL.glVertex2f(a, b)
      OpenGL.glVertex2f(c, d)
      OpenGL.glVertex2f(e, f)
      OpenGL.glEnd
    end

    def circleUnit(style = LINE_LOOP, div = nil)
      div = 32 if div.nil?
      e = 2 * Math::PI / div
      OpenGL.glBegin(style)
      div.times {|i|
	rad = i * e
	x = Math.cos(rad)
	y = Math.sin(rad)
	OpenGL.glVertex2f(x, y)
      }
      OpenGL.glEnd
    end
    private :circleUnit

    def circle(x, y, r, style = LINE_LOOP, div = nil)
      OpenGL.glPushMatrix
      OpenGL.glTranslate(x, y, 0)
      OpenGL.glScalef(r, r, r)
      circleUnit(style, div)
      OpenGL.glPopMatrix
    end

    def box(x1, y1, z1, x2, y2, z2)
      box = [
	[x1, y1, z1], # 0 back left bottom
	[x2, y1, z1], # 1 back right bottom
	[x2, y2, z1], # 2 back right top
	[x1, y2, z1], # 3 back left top
	[x1, y1, z2], # 4 front left bottom
	[x2, y1, z2], # 5 front right bottom
	[x2, y2, z2], # 6 front right top
	[x1, y2, z2]  # 7 front left top
      ]
      OpenGL.glBegin(OpenGL::GL_QUADS)
      OpenGL.glVertex(box[1]) # back
      OpenGL.glVertex(box[0])
      OpenGL.glVertex(box[3])
      OpenGL.glVertex(box[2])
      OpenGL.glVertex(box[0]) # left
      OpenGL.glVertex(box[4])
      OpenGL.glVertex(box[7])
      OpenGL.glVertex(box[3])
      OpenGL.glVertex(box[4]) # front
      OpenGL.glVertex(box[5])
      OpenGL.glVertex(box[6])
      OpenGL.glVertex(box[7])
      OpenGL.glVertex(box[5]) # right
      OpenGL.glVertex(box[1])
      OpenGL.glVertex(box[2])
      OpenGL.glVertex(box[6])
      OpenGL.glVertex(box[7]) # top
      OpenGL.glVertex(box[6])
      OpenGL.glVertex(box[2])
      OpenGL.glVertex(box[3])
      OpenGL.glVertex(box[0]) # bottom
      OpenGL.glVertex(box[1])
      OpenGL.glVertex(box[5])
      OpenGL.glVertex(box[4])
      OpenGL.glEnd
    end

    def cube(x, y, z, s)
      s = s / 2
      box(x - s, y - s, z - s, x + s, y + s, z + s)
    end
  end

  # This class is not used for now.
  class FasterCircle
    # circle
    def self.circleUnit(style=LINE_LOOP, div=nil)
      div = 32 if div == nil
      e = 2 * Math::PI / div
      beginObj(style)
      div.times {|i|
	rad = i * e
	x = Math.cos(rad)
	y = Math.sin(rad)
	vertex(x, y)
      }
      endObj()
    end

    def self.make_list
      OpenGL.glNewList(1, OpenGL::GL_COMPILE)
      self.circleUnit(LINE_LOOP, 32)
      OpenGL.glEndList()
      OpenGL.glNewList(2, OpenGL::GL_COMPILE)
      self.circleUnit(POLYGON, 32)
      OpenGL.glEndList()
      OpenGL.glNewList(3, OpenGL::GL_COMPILE)
      self.circleUnit(LINE_LOOP, 6)
      OpenGL.glEndList()
      OpenGL.glNewList(4, OpenGL::GL_COMPILE)
      self.circleUnit(POLYGON, 6)
      OpenGL.glEndList()
    end

    def self.circleUnitList(style=LINE_LOOP, div=nil)
      if div == 32
	if style == LINE_LOOP
	  OpenGL.glCallList(1)
	elsif style == POLYGON
	  OpenGL.glCallList(2)
	end
      elsif div == 6
	if style == LINE_LOOP
	  OpenGL.glCallList(3)
	elsif style == POLYGON
	  OpenGL.glCallList(4)
	end
      end
    end

    def self.circle(x, y, r, style=LINE_LOOP, div=nil)
      push()
      translate(x, y)
      scale(r)
      #circleUnit(style, div)
      self.circleUnitList(style, div)
      pop()
    end
  end
end

include SGL
$__a__ = SGL::Application.new
