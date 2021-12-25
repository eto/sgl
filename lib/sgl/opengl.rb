#!/usr/bin/env ruby -w
# coding: utf-8
# Copyright (C) 2004-2021 Koichiro Eto, All rights reserved.
# License: BSD 3-Clause License

$basic_private_methods = private_methods(false)
$basic_public_methods = public_methods(false)

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

#require "gl"
#include Gl

require "glu"
GLU.load_lib()
#include GLU

#require "glut"
#include Glut

#require "mathn"

require "sdl2"
require "sgl/sgl-color"
#require "sgl/sgl-sound"

def sh(cmd); p cmd; system cmd; end
def die(msg); puts msg; exit; end

at_exit {
  mainloop
}

module SGL
  if ! defined?(LINES)
    LINES	= OpenGL::GL_LINES	# from opengl-draw.rb
    POINTS	= OpenGL::GL_POINTS
    LINE_STRIP	= OpenGL::GL_LINE_STRIP
    LINE_LOOP	= OpenGL::GL_LINE_LOOP
    TRIANGLES	= OpenGL::GL_TRIANGLES
    TRIANGLE_STRIP	= OpenGL::GL_TRIANGLE_STRIP
    TRIANGLE_FAN	= OpenGL::GL_TRIANGLE_FAN
    QUADS	= OpenGL::GL_QUADS
    QUAD_STRIP	= OpenGL::GL_QUAD_STRIP
    POLYGON	= OpenGL::GL_POLYGON
  end
  def window(*a)	$__a__.window(*a)	end	# window functions
  #def close_window()	$__a__.close_window;	end
  def width()	$__a__.width;	end
  def height()	$__a__.height;	end
  def useFov(*a)	$__a__.useFov(*a);	end	# opengl specific functions
  def useDepth(*a)	$__a__.useDepth(*a)	end
  def useSmooth(*a)	$__a__.useSmooth(*a)	end
  def useCulling(*a)	$__a__.useCulling(*a)	end
  def useFullscreen(*a)	$__a__.useFullscreen(*a)	end
  alias useFullScreen useFullscreen
  def useCursor(*a)	$__a__.useCursor(*a)	end
  def background(*a)	$__a__.background(*a)	end	# from opengl-color.rb
  def backgroundHSV(*a)	$__a__.backgroundHSV(*a)	end
  def color(*a)		$__a__.color(*a)	end
  def colorHSV(*a)	$__a__.colorHSV(*a)	end

  def setup()		end	# callback functions from opengl-event.rb
  def onMouseDown(x,y)	end
  def onMouseUp(x,y)	end
  def onKeyDown(k)	end
  def onKeyUp(k)	end
  def display()		end
  def onMouseDown0(x,y)	end	# callback functions for fullscreen
  def display0()	end

  def mouseX()	$__a__.mouseX;	end	# get status functions
  def mouseY()	$__a__.mouseY;	end
  def mouseDown()	$__a__.mouseDown;	end
  def key(k)	$__a__.key[k];	end
  def keynum()	$__a__.keynum;	end
  def mouseX0()	$__a__.mouseX0;	end	# get status functions for fullscreen
  def mouseY0()	$__a__.mouseY0;	end
  def useDelay(*a)	$__a__.useDelay(*a)	end	# event control
  def useFramerate(*a)	$__a__.useFramerate(*a)	end
  def useRuntime(*a)	$__a__.useRuntime(*a)	end
  def beginObj(*a)	$__a__.beginObj(*a)	end	# from opengl-draw.rb
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

  def mainloop
    if ! defined?($__sgl_in_mainloop__)	# 2回呼ばれないようにしている。
      $__sgl_in_mainloop__ = true
      setup
      $__a__.set_starttime
      loop {
        $__a__.set_begintime
        @display_drawing = true
        $__a__.display_pre
        display
        $__a__.display_post
	$__a__.delay
	return if $__a__.check_runtime_finished
      }
    else
      setup
    end
  end

  # ====================================================================== opengl-app.rb
  class Application
    def initialize
      Thread.abort_on_exception = true
      @options = default_options
      initialize_window	# opengl-window.rb
      initialize_color	# opengl-color.rb
      initialize_event	# opengl-event.rb
    end

    private def default_options
      {
	:fullscreen	=>nil,
	:fov	=>45,
	:cursor	=>nil,
	:depth	=>false,
	:culling	=>false,
	:smooth	=>false,
	:delaytime	=>nil,
	:framerate	=>60,
	:runtime	=>nil,
      }
    end

    #====================================================================== from opengl-window.rb
    private def initialize_window
      @default_window_width  = 100
      @default_window_height = 100
      @default_fullscreen_width  = 1024
      @default_fullscreen_height = 768
      @width, @height = @default_window_width, @default_window_height
      @left, @bottom, @right, @top = 0, 0, @width, @height
      @cameraX, @cameraY, @cameraZ = 0, 0, 5
      @window_initialized = false

      SDL2.init(SDL2::INIT_EVERYTHING)	# initialize_sdl
=begin
      SDL2::GL.set_attribute(SDL2::GL::RED_SIZE, 5)	# Setting color size is important for Mac OS X. But why I choose 5 for color size?
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
      #SDL2.setVideoMode(640, 400, 16, SDL2::OPENGL) if !windows?
    end
    private def windows?;	r = RUBY_PLATFORM; (r.index("cygwin") || r.index("mswin32") || r.index("mingw32")) != nil; end

    def window(*a)	# create window
      return if @window_initialized

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
      @sdl_window = SDL2::Window.create("sgl", 0, 0, @width, @height + 1, SDL2::Window::Flags::OPENGL)	# なぜ縦だけ＋1なのか？
      sdl_context = SDL2::GL::Context.create(@sdl_window)
      @window_initialized = true

      if @options[:cursor]	# setCurosr. You can use only black and white for cursor image.
	file = @options[:cursor]
	bmp = SDL2::Surface.load_bmp(file) # Create surface from bitmap.
#	SDL2::Mouse.setCursor(bmp,		# bitmap
#			     [255, 255, 255],	# white
#			     [  0,   0,   0],	# black
#			     [128, 128, 128],	# transparent
#			     [100, 100, 100],	# inverted
#			     8, 8)		# hot_x, hot_y
      end

=begin
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

      #display_pre
      check_event
=end
    end

    def get_opengl_version
      major = SDL2::GL.get_attribute(SDL2::GL::CONTEXT_MAJOR_VERSION)
      minor = SDL2::GL.get_attribute(SDL2::GL::CONTEXT_MINOR_VERSION)
      return "OpenGL version #{major}.#{minor}"
    end

    attr_reader :width, :height	# get window size

    def useFov(f = 45);	@options[:fov] = f;	end	# world control methods
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
    def useFullscreen(w = @default_fullscreen_width, h = @default_fullscreen_height)
      if @options[:fullscreen].nil?
        @options[:fullscreen] = (w.nil? || h.nil?) ? nil : [w, h]
      end
    end
    def useCursor(bmpfile);	@options[:cursor] = bmpfile;	end
    def useDelay(sec);		@options[:delaytime] = sec;	end
    def useFramerate(f);	@options[:framerate] = f;	end
    def useRuntime(r);		@options[:runtime] = r;	end
    def runtime=(r);		useRuntime(r);	end
    private def set_window_position
      @cameraX, @cameraY = ((@left + @right)/2), ((@bottom + @top)/2)
      fov = @options[:fov]
      @cameraZ = 1.0 + @height / (2.0 * Math.tan(Math::PI * (fov/2.0) / 180.0))
      OpenGL.glViewport(0, 0, @width, @height)
      OpenGL.glMatrixMode(OpenGL::GL_PROJECTION)
      OpenGL.glLoadIdentity
      GLU.gluPerspective(fov, @width/@height.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
    end

    private def set_fullscreen_position
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
      OpenGL.glLoadIdentity
      fov = @options[:fov]
      @cameraZ = 1.0 + h / (2.0 * Math.tan(Math::PI * (fov/2.0) / 180.0));
      GLU.gluPerspective(fov, w/h.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
    end

    private def set_camera_position
      die "Window is not initialized." if ! @window_initialized
      OpenGL.glMatrixMode(OpenGL::GL_PROJECTION)
      OpenGL.glLoadIdentity
      OpenGL.glMatrixMode(OpenGL::GL_MODELVIEW)
      GLU.gluLookAt(@cameraX, @cameraY, @cameraZ,
		    @cameraX, @cameraY, 0,
		    0, 1, 0)
    end

    private def set_fullscreen_camera_position
      OpenGL.glMatrixMode(OpenGL::GL_MODELVIEW)
      OpenGL.glLoadIdentity
      GLU.gluLookAt(0, 0, @cameraZ,
		    0, 0, 0,
		    0, 1, 0)
    end

    #private def loadIdentity;	OpenGL.glLoadIdentity;	end

    # ====================================================================== from opengl-color.rb
    private def initialize_color
      @bg_color = @cur_color = nil
      @rgb = ColorTranslatorRGB.new(100, 100, 100, 100)
      @hsv = ColorTranslatorHSV.new(100, 100, 100, 100)
    end

    def background(x, y = nil, z = nil, a = nil)
      norm = @rgb.norm(x, y, z, a)
      p [x, y, z, a, norm]
      OpenGL.glClearColor(*norm)
      clear
    end
    def backgroundHSV(x, y = nil, z = nil, a = nil);	OpenGL.glClearColor(*@hsv.norm(x, y, z, a));	clear;	end
    private def clear;	OpenGL.glClear(OpenGL::GL_COLOR_BUFFER_BIT | OpenGL::GL_DEPTH_BUFFER_BIT);	end
    def color(x, y = nil, z = nil, a = nil)
      @cur_color = [x, y, z, a]
      norm = @rgb.norm(x, y, z, a)
      #p [x, y, z, a, norm]
      OpenGL.glColor4f(*norm)
    end
    def colorHSV(x, y = nil, z = nil, a = nil);	OpenGL.glColor4f(*@hsv.norm(x, y, z, a));	end

    #====================================================================== from opengl-event.rb
    private def initialize_event
      @setup_done = nil
      @display_drawing = nil
      @block = {}
      @starttime = nil
      @mouseX, @mouseY = 0, 0	# status setting
      @mouseX0, @mouseY0 = 0, 0
      @mouseDown = 0
      @keynum = 0
    end
    # get status
    attr_reader :mouseX, :mouseY
    attr_reader :mouseX0, :mouseY0
    attr_reader :mouseDown
    attr_reader :keynum

    def display_pre
      set_camera_position
      check_event
      clear
    end

    def display_post
      set_fullscreen_camera_position
      cur_color = @cur_color
      #send(:display0) if respond_to?(:display0)
      color(*cur_color)
      @sdl_window.gl_swap
      #SDL2.GLSwapBuffers
      #GC.start
    end

    # mouse events
    def do_mousedown
      @mouseDown = 1
      #if respond_to?(:onMouseDown)
      onMouseDown(@mouseX, @mouseY)
      #mouseDown0(@mouseX, @mouseY)
    end

    def do_mouseup
      @mouseDown = 0
      #if respond_to?(:onMouseUp)
      onMouseUp(@mouseX, @mouseY)
    end

    # key events
    private def keydown_pre(key)
      exit if key == SDL2::Key::ESCAPE
    end

    def do_keydown(key)
      keydown_pre(key)
      #if respond_to?(:onKeyDown)
      onKeyDown(key)
    end

    def do_keyup(key)
      #if respond_to?(:onKeyUp)
      onKeyUp(key)
    end

    private def calc_keynum(e)
      input = e.characters
      @keynum = input.to_s[0]
    end

    def set_starttime;	@starttime = Time.now;	end
    def set_begintime;	@begintime = Time.now;	end
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

    def check_runtime_finished
      starttime = @starttime
      runtime = @options[:runtime]
      return false if runtime.nil?
      diff = Time.now - starttime
      return (runtime && runtime < diff)
    end

    private def check_event	# check event
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

    private def calc_mouse_xy(x, y)
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

    private def calc_fullscreen_mouse_xy(x, y)
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

    #====================================================================== from opengl-draw.rb
    def beginObj(mode = POLYGON);	OpenGL.glBegin(mode);	end	# draw primitive
    def endObj;	OpenGL.glEnd;	end
    def push;	OpenGL.glPushMatrix;	end
    def pop;	OpenGL.glPopMatrix;	end
    def vertex(a, b = nil, c = nil, d = nil)
      OpenGL.glVertex4f(a, b, c, d) if d
      OpenGL.glVertex3f(a, b, c) if c
      OpenGL.glVertex2f(a, b)
    end
    def normal(a, b = nil, c = nil);	OpenGL.glNormal(a, b, c);	end
    def translate(a, b, c = 0);	OpenGL.glTranslatef(a, b, c);	end	# matrix manipulation
    def rotateX(a);	OpenGL.glRotatef(a, 1, 0, 0);	end
    def rotateY(a);	OpenGL.glRotatef(a, 0, 1, 0);	end
    def rotateZ(a);	OpenGL.glRotatef(a, 0, 0, 1);	end
    def scale(a);	OpenGL.glScalef(a, a, a);	end
    def point(a, b, c = nil)	# simple draw
      OpenGL.glBegin(OpenGL::GL_POINTS)
      if c; OpenGL.glVertex3f(a, b, c); else; OpenGL.glVertex2f(a, b); end
      OpenGL.glEnd
    end
    def lineWidth(w);	OpenGL.glLineWidth(w);	end
    def line(a, b, c, d, e = nil, f = nil)
      #p [a, b, c, d, e, f]
      #color 100
      OpenGL.glBegin(OpenGL::GL_LINES)
      if e && f
	OpenGL.glVertex3f(a, b, c) # 3D
	OpenGL.glVertex3f(d, e, f)
      else
	OpenGL.glVertex2f(a, b) # 2D
	OpenGL.glVertex2f(c, d)
      end
      OpenGL.glEnd
      test_display
    end

    def test_display
      init_viewport
      OpenGL.glClearColor(0.0, 0.0, 0.0, 1.0);
      OpenGL.glClear(OpenGL::GL_COLOR_BUFFER_BIT | OpenGL::GL_DEPTH_BUFFER_BIT);
      #glRotated(GLFW.glfwGetTime() * 5.0, 1.0, 1.0, 1.0)
      now = (Time.now.to_f * 1000.0).to_i
      #p now
      OpenGL.glRotated(now * 5.0, 1.0, 1.0, 1.0)
      #draw_cube
      draw_triangle
      draw_triangle2
      OpenGL.glMatrixMode(OpenGL::GL_MODELVIEW)
      #glRotated(5.0, 1.0, 1.0, 1.0)
    end

    def init_viewport
      #glViewport( 0, 0, 640, 400 )
      OpenGL.glViewport(0, 0, @width, @height)
      OpenGL.glMatrixMode(OpenGL::GL_PROJECTION)
      OpenGL.glLoadIdentity
      OpenGL.glMatrixMode(OpenGL::GL_MODELVIEW)
      OpenGL.glLoadIdentity
      OpenGL.glEnable(OpenGL::GL_DEPTH_TEST)
      OpenGL.glDepthFunc(OpenGL::GL_LESS)
      OpenGL.glShadeModel(OpenGL::GL_SMOOTH)
    end

    def draw_triangle
      OpenGL.glBegin(OpenGL::GL_TRIANGLES)
      OpenGL.glColor3f(1.0, 0.0, 0.0)
      OpenGL.glVertex3f(-0.6, -0.4, 0.0)
      OpenGL.glColor3f(0.0, 1.0, 0.0)
      OpenGL.glVertex3f(0.6, -0.4, 0.0)
      OpenGL.glColor3f(0.0, 0.0, 1.0)
      OpenGL.glVertex3f(0.0, 0.6, 0.0)
      OpenGL.glEnd()
    end

    def draw_triangle2
      s = 2.0
      #qp s
      OpenGL.glBegin(OpenGL::GL_TRIANGLES)
      OpenGL.glColor3f(1.0, 0.0, 0.0)
      OpenGL.glVertex3f(-0.6 * s, -0.4 * s, 0.0 * s)
      OpenGL.glColor3f(0.0, 1.0, 0.0)
      OpenGL.glVertex3f(0.6 * s, -0.4 * s, 0.0 * s)
      OpenGL.glColor3f(0.0, 0.0, 1.0)
      OpenGL.glVertex3f(0.0 * s, 0.6 * s, 0.0 * s)
      OpenGL.glEnd()
    end

    def rect(a, b, c, d);	OpenGL.glRectf(a, b, c, d);	end
    def triangle(a, b, c, d, e, f)
      OpenGL.glBegin(OpenGL::GL_TRIANGLES)
      OpenGL.glVertex2f(a, b)
      OpenGL.glVertex2f(c, d)
      OpenGL.glVertex2f(e, f)
      OpenGL.glEnd
    end
    def circle(x, y, r, style = LINE_LOOP, div = nil)
      OpenGL.glPushMatrix
      OpenGL.glTranslate(x, y, 0)
      OpenGL.glScalef(r, r, r)
      circleUnit(style, div)
      OpenGL.glPopMatrix
    end
    private def circleUnit(style = LINE_LOOP, div = nil)
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
end

include SGL
$__a__ = SGL::Application.new if ! defined?($__a__)
