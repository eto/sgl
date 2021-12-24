#!/usr/bin/env ruby
# coding: utf-8

require 'opengl'
require 'glfw'
OpenGL.load_lib()
GLFW.load_lib()
include OpenGL
include GLFW

class SGLApp
  def initialize
    glfw_init
  end

  def glfw_init
    # Press ESC to exit.
    @key_callback = GLFW::create_callback(:GLFWkeyfun) do |window_handle, key, scancode, action, mods|
      if key == GLFW_KEY_ESCAPE && action == GLFW_PRESS
        glfwSetWindowShouldClose(window_handle, 1)
      end
    end

    glfwInit()
    @window = glfwCreateWindow( 640, 480, "Simple example", nil, nil )
    glfwMakeContextCurrent( @window )
    glfwSetKeyCallback( @window, @key_callback )
  end

  def main(argv)
    mainloop
  end

  def mainloop
    loop do
      ret = display
      if ret
        glfwDestroyWindow( @window )
        glfwTerminate()
        exit
      end
    end
  end

  def display
    glfw_display
  end

  def glfw_display
    close = glfwWindowShouldClose( @window )
    if close != 0
      return true
    end

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

    glfwSwapBuffers( @window )
    glfwPollEvents()
    return false
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
