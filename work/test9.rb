#!/usr/bin/env ruby
# coding: utf-8

class SGLApp
  def setup
    #window 100,100
    #window 1000,1000
    #background 0, 10, 20
    #window 900, 900
    sdl_init
  end

  def initialize
    window_w = 640
    window_h = 480
    @shadedCube = true
    SDL2.init(SDL2::INIT_EVERYTHING)
    SDL2::GL.set_attribute(SDL2::GL::RED_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::GREEN_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::BLUE_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::ALPHA_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::DOUBLEBUFFER, 1)
    @window = SDL2::Window.create("testgl", 0, 0, window_w, window_h, SDL2::Window::Flags::OPENGL)
    context = SDL2::GL::Context.create(@window)
    printf("OpenGL version %d.%d\n",
           SDL2::GL.get_attribute(SDL2::GL::CONTEXT_MAJOR_VERSION),
           SDL2::GL.get_attribute(SDL2::GL::CONTEXT_MINOR_VERSION))
    glViewport( 0, 0, 640, 400 )
    glMatrixMode( GL_PROJECTION )
    glLoadIdentity( )
    glMatrixMode( GL_MODELVIEW )
    glLoadIdentity( )
    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LESS)
    glShadeModel(GL_SMOOTH)
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
  end

  def display
    #p "display"
    color 100, 90, 80
    line 0, 0, 1000, 1000
    rect 200, 200, 800, 800
  end

  def main(argv)
    loop do
      while event = SDL2::Event.poll
        case event
        when SDL2::Event::Quit, SDL2::Event::KeyDown
          exit
        end
      end
      glClearColor(0.0, 0.0, 0.0, 1.0);
      glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
      glBegin(GL_QUADS)
      color = @color
      cube = @cube
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
      glEnd()
      glMatrixMode(GL_MODELVIEW)
      glRotated(5.0, 1.0, 1.0, 1.0)
      @window.gl_swap
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
