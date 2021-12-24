#!/usr/bin/env ruby
# coding: utf-8

require 'opengl'
require 'glfw'
OpenGL.load_lib()
GLFW.load_lib()
include OpenGL

class SGLApp
  def main(argv)
    #@sdl_engine = SDLEngine.new
    @glfw_engine = GLFWEngine.new
    @window_w = 640
    @window_h = 480
    @title = "Engine Test"

    #@sdl_engine.setup(@window_w, @window_h, @title)
    @glfw_engine.setup(@window_w, @window_h, @title)
    mainloop
  end

  def mainloop
    loop do
      sdl_ret = false
      #sdl_ret = @sdl_engine.pre_display
      glfw_ret = @glfw_engine.pre_display
      if sdl_ret || glfw_ret
        #@sdl_engine.terminate
        @glfw_engine.terminate
        exit
      end
      #@sdl_engine.display
      @glfwdl_engine.display
      #@sdl_engine.post_display
      @glfw_engine.post_display
    end
  end
end

class OpenGLEngine
  def setup(w, h, title)
    @window_w = w
    @window_h = h
    @title = title
  end

  def mainloop
  end

  def pre_display
  end

  def display
  end

  def post_display
  end

  def terminate
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
    glBegin(GL_QUADS)
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
  end

  def draw_triangle
    glBegin(GL_TRIANGLES)
    glColor3f(1.0, 0.0, 0.0)
    glVertex3f(-0.6, -0.4, 0.0)
    glColor3f(0.0, 1.0, 0.0)
    glVertex3f(0.6, -0.4, 0.0)
    glColor3f(0.0, 0.0, 1.0)
    glVertex3f(0.0, 0.6, 0.0)
    glEnd()
  end
end

class SDLEngine < OpenGLEngine
  def setup(w, h, title)
    super
    SDL2.init(SDL2::INIT_EVERYTHING)
    SDL2::GL.set_attribute(SDL2::GL::RED_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::GREEN_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::BLUE_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::ALPHA_SIZE, 8)
    SDL2::GL.set_attribute(SDL2::GL::DOUBLEBUFFER, 1)
    @window = SDL2::Window.create("SDL: "+@title, 0, 0, @window_w, @window_h, SDL2::Window::Flags::OPENGL)
    context = SDL2::GL::Context.create(@window)
    #puts get_opengl_version
    #init_viewport
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
      when SDL2::Event::Quit
        endprocess = true
      when SDL2::Event::KeyDown
	keynum = event.scancode
        if keynum == 41		# Why it's different from SDL2::Key::ESCAPE(27)?
          endprocess = true
        end
      end
    end
    return endprocess
  end

  def display
    init_viewport
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    #glRotated(GLFW.glfwGetTime() * 5.0, 1.0, 1.0, 1.0)
    draw_cube
    #draw_triangle
    glMatrixMode(GL_MODELVIEW)
    glRotated(5.0, 1.0, 1.0, 1.0)
  end

  def init_viewport
    #glViewport( 0, 0, 640, 400 )
    glViewport(0, 0, @window_w, @window_h)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity( )
    glMatrixMode( GL_MODELVIEW )
    glLoadIdentity( )
    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LESS)
    glShadeModel(GL_SMOOTH)
  end

  def post_display
    @window.gl_swap
  end
end

class GLFWEngine < OpenGLEngine
  def setup(w, h, title)
    super

    # Press ESC to exit.
    @key_callback = GLFW::create_callback(:GLFWkeyfun) do |window_handle, key, scancode, action, mods|
      if key == GLFW::GLFW_KEY_ESCAPE && action == GLFW::GLFW_PRESS
        GLFW.glfwSetWindowShouldClose(window_handle, 1)
      end
    end

    GLFW.glfwInit()
    @window = GLFW.glfwCreateWindow(@window_w, @window_h, "GLFW: "+@title, nil, nil)
    GLFW.glfwMakeContextCurrent(@window)
    GLFW.glfwSetKeyCallback(@window, @key_callback)
  end

  def pre_display
    close = GLFW.glfwWindowShouldClose(@window)
    return true if close != 0
    return false
  end

  def display
    init_viewport
#    glClearColor(0.0, 0.0, 0.0, 1.0);
#    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glRotatef(GLFW.glfwGetTime() * 50.0, 0.0, 0.0, 1.0)
    #draw_cube
    draw_triangle
  end

  def init_viewport
    width, height = get_framebuffersize
    ratio = width.to_f / height.to_f

    glViewport(0, 0, width, height)
    glClear(GL_COLOR_BUFFER_BIT)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0)
    glMatrixMode(GL_MODELVIEW)

    glLoadIdentity()
  end

  def get_framebuffersize
    width_ptr = ' ' * 8
    height_ptr = ' ' * 8
    GLFW.glfwGetFramebufferSize(@window, width_ptr, height_ptr)
    width = width_ptr.unpack('L')[0]
    height = height_ptr.unpack('L')[0]
    return width, height
  end

  def post_display
    GLFW.glfwSwapBuffers(@window)
    GLFW.glfwPollEvents()
  end

  def terminate
    GLFW.glfwDestroyWindow(@window)
    GLFW.glfwTerminate()
  end
end
