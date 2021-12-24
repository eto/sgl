#!/usr/bin/env ruby
# coding: utf-8

require 'opengl'
require 'glfw'
OpenGL.load_lib()
GLFW.load_lib()
include OpenGL
include GLFW

class SDLEngine
  def initialize
  end

  def setup(w, h, title)
    @window_w = w
    @window_h = h
    @title = title

    SDL2.init(SDL2::INIT_EVERYTHING)
    SDL2::GL.set_attribute(SDL2::GL::RED_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::GREEN_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::BLUE_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::ALPHA_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::DOUBLEBUFFER, 1)
    @window = SDL2::Window.create(@title, 0, 0, @window_w, @window_h, SDL2::Window::Flags::OPENGL)
    context = SDL2::GL::Context.create(@window)
    puts get_opengl_version

    glViewport( 0, 0, 640, 400 )
    glMatrixMode( GL_PROJECTION )
    glLoadIdentity( )
    glMatrixMode( GL_MODELVIEW )
    glLoadIdentity( )
    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LESS)
    glShadeModel(GL_SMOOTH)
  end

  def get_opengl_version
    major = SDL2::GL.get_attribute(SDL2::GL::CONTEXT_MAJOR_VERSION)
    minor = SDL2::GL.get_attribute(SDL2::GL::CONTEXT_MINOR_VERSION)
    return "OpenGL version #{major}.#{minor}"
  end

  def pre_display
    endprocess = false
    while event = SDL2::Event.poll
      case event
      when SDL2::Event::Quit, SDL2::Event::KeyDown
        endprocess = true
      end
    end
    return endprocess
  end

  def display
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glBegin(GL_QUADS)
    draw_cube
    glEnd()
    glMatrixMode(GL_MODELVIEW)
    glRotated(5.0, 1.0, 1.0, 1.0)
  end

  def draw_cube
    @color =
      [[ 1.0,  1.0,  0.0].pack("D3"),
       [ 1.0,  0.0,  0.0].pack("D3"),
       [ 0.0,  0.0,  0.0].pack("D3"),
       [ 0.0,  1.0,  0.0].pack("D3"),
       [ 0.0,  1.0,  1.0].pack("D3"),
       [ 1.0,  1.0,  1.0].pack("D3"),
       [ 1.0,  0.0,  1.0].pack("D3"),
       [ 0.0,  0.0,  1.0].pack("D3")]
    @cube =
      [[ 0.5,  0.5, -0.5].pack("D3"),
       [ 0.5, -0.5, -0.5].pack("D3"),
       [-0.5, -0.5, -0.5].pack("D3"),
       [-0.5,  0.5, -0.5].pack("D3"),
       [-0.5,  0.5,  0.5].pack("D3"),
       [ 0.5,  0.5,  0.5].pack("D3"),
       [ 0.5, -0.5,  0.5].pack("D3"),
       [-0.5, -0.5,  0.5].pack("D3")]
    color = @color
    cube = @cube
    @shadedCube = true
    if @shadedCube then
      glColor3dv(color[0])
      glVertex3dv(cube[0])
      glColor3dv(color[1])
      glVertex3dv(cube[1])
      glColor3dv(color[2])
      glVertex3dv(cube[2])
      glColor3dv(color[3])
      glVertex3dv(cube[3])

      glColor3dv(color[3])
      glVertex3dv(cube[3])
      glColor3dv(color[4])
      glVertex3dv(cube[4])
      glColor3dv(color[7])
      glVertex3dv(cube[7])
      glColor3dv(color[2])
      glVertex3dv(cube[2])

      glColor3dv(color[0])
      glVertex3dv(cube[0])
      glColor3dv(color[5])
      glVertex3dv(cube[5])
      glColor3dv(color[6])
      glVertex3dv(cube[6])
      glColor3dv(color[1])
      glVertex3dv(cube[1])

      glColor3dv(color[5])
      glVertex3dv(cube[5])
      glColor3dv(color[4])
      glVertex3dv(cube[4])
      glColor3dv(color[7])
      glVertex3dv(cube[7])
      glColor3dv(color[6])
      glVertex3dv(cube[6])

      glColor3dv(color[5])
      glVertex3dv(cube[5])
      glColor3dv(color[0])
      glVertex3dv(cube[0])
      glColor3dv(color[3])
      glVertex3dv(cube[3])
      glColor3dv(color[4])
      glVertex3dv(cube[4])

      glColor3dv(color[6])
      glVertex3dv(cube[6])
      glColor3dv(color[1])
      glVertex3dv(cube[1])
      glColor3dv(color[2])
      glVertex3dv(cube[2])
      glColor3dv(color[7])
      glVertex3dv(cube[7])
    else
      glColor3d(1.0, 0.0, 0.0)
      glVertex3dv(cube[0])
      glVertex3dv(cube[1])
      glVertex3dv(cube[2])
      glVertex3dv(cube[3])

      glColor3d(0.0, 1.0, 0.0)
      glVertex3dv(cube[3])
      glVertex3dv(cube[4])
      glVertex3dv(cube[7])
      glVertex3dv(cube[2])

      glColor3d(0.0, 0.0, 1.0)
      glVertex3dv(cube[0])
      glVertex3dv(cube[5])
      glVertex3dv(cube[6])
      glVertex3dv(cube[1])

      glColor3d(0.0, 1.0, 1.0)
      glVertex3dv(cube[5])
      glVertex3dv(cube[4])
      glVertex3dv(cube[7])
      glVertex3dv(cube[6])

      glColor3d(1.0, 1.0, 0.0)
      glVertex3dv(cube[5])
      glVertex3dv(cube[0])
      glVertex3dv(cube[3])
      glVertex3dv(cube[4])

      glColor3d(1.0, 0.0, 1.0)
      glVertex3dv(cube[6])
      glVertex3dv(cube[1])
      glVertex3dv(cube[2])
      glVertex3dv(cube[7])
    end
  end

  def post_display
    @window.gl_swap
  end

  def terminate
  end
end

class GLFWEngine
  def initialize
    @window = nil
    @key_callback = nil
  end

  def setup(w, h, title)
    @window_w = w
    @window_h = h
    @title = title

    # Press ESC to exit.
    @key_callback = GLFW::create_callback(:GLFWkeyfun) do |window_handle, key, scancode, action, mods|
      if key == GLFW_KEY_ESCAPE && action == GLFW_PRESS
        glfwSetWindowShouldClose(window_handle, 1)
      end
    end

    glfwInit()
    @window = glfwCreateWindow(@window_w, @window_h, @title, nil, nil )
    glfwMakeContextCurrent(@window)
    glfwSetKeyCallback(@window, @key_callback)
  end

  def pre_display
    #p "glfw_display"
    close = glfwWindowShouldClose(@window)
    #p close
    if close != 0
      return true
    end
  end

  def display
    width_ptr = ' ' * 8
    height_ptr = ' ' * 8
    glfwGetFramebufferSize(@window, width_ptr, height_ptr)
    width = width_ptr.unpack('L')[0]
    height = height_ptr.unpack('L')[0]
    ratio = width.to_f / height.to_f

    glViewport(0, 0, width, height)
    glClear(GL_COLOR_BUFFER_BIT)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0)
    glMatrixMode(GL_MODELVIEW)

    glLoadIdentity()
    glRotatef(glfwGetTime() * 50.0, 0.0, 0.0, 1.0)

    glBegin(GL_TRIANGLES)
    glColor3f(1.0, 0.0, 0.0)
    glVertex3f(-0.6, -0.4, 0.0)
    glColor3f(0.0, 1.0, 0.0)
    glVertex3f(0.6, -0.4, 0.0)
    glColor3f(0.0, 0.0, 1.0)
    glVertex3f(0.0, 0.6, 0.0)
    glEnd()
  end

  def post_display
    glfwSwapBuffers(@window)
    glfwPollEvents()
    return false
  end

  def terminate
    glfwDestroyWindow(@window)
    glfwTerminate()
  end
end

class SGLApp
  def initialize
    @engine = SDLEngine.new
    #@engine = GLFWEngine.new
    @window_w = 640
    @window_h = 480
    @title = "Engine Test"
    @engine.setup(@window_w, @window_h, @title)
  end

  def main(argv)
    mainloop
  end

  def mainloop
    loop do
      ret = @engine.pre_display
      if ret
        ret = @engine.terminate
        exit
      end
      @engine.display
      @engine.post_display
    end
  end
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
end
