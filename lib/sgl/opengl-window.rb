# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

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

  class Application
    DEFAULT_WINDOW_WIDTH  = 100
    DEFAULT_WINDOW_HEIGHT = 100
    DEFAULT_FULLSCREEN_WIDTH  = 1024
    DEFAULT_FULLSCREEN_HEIGHT = 768

    def initialize_window
      @width, @height = DEFAULT_WINDOW_WIDTH, DEFAULT_WINDOW_HEIGHT
      @left, @bottom, @right, @top = 0, 0, @width, @height
      @cameraX, @cameraY, @cameraZ = 0, 0, 5
      initialize_sdl
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
      glEnable(GL_BLEND)
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
      glShadeModel(GL_SMOOTH)
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
      @options[:depth] ? glEnable(GL_DEPTH_TEST) : glDisable(GL_DEPTH_TEST)
    end

    def useSmooth(a = true)
      @options[:smooth] = a
      #@options[:smooth] ? glEnable(GL_LINE_SMOOTH) : glDisable(GL_LINE_SMOOTH)
    end

    def useCulling(a = true)
      @options[:culling] = a
      @options[:culling] ? glEnable(GL_CULL_FACE) : glDisable(GL_CULL_FACE)
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
      glViewport(0, 0, @width, @height)
      glMatrixMode(GL_PROJECTION)
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
      glViewport(0, 0, w, h)
      glMatrixMode(GL_PROJECTION)
      loadIdentity
      fov = @options[:fov]
      @cameraZ = 1.0 + h / (2.0 * Math.tan(Math::PI * (fov/2.0) / 180.0));
      #gluPerspective(fov, w/h.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
      gluPerspective(fov, w/h.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
    end
    private :set_window_position, :set_fullscreen_position

    def set_camera_position
      #pp caller
      #exit
      glMatrixMode(GL_PROJECTION)
      #exit
      loadIdentity
      glMatrixMode(GL_MODELVIEW)
      gluLookAt(@cameraX, @cameraY, @cameraZ,
		 @cameraX, @cameraY, 0,
		 0, 1, 0)
    end

    def set_fullscreen_camera_position
      glMatrixMode(GL_MODELVIEW)
      loadIdentity
      gluLookAt(0, 0, @cameraZ,
		 0, 0, 0,
		 0, 1, 0)
    end
    private :set_camera_position, :set_fullscreen_camera_position

    def loadIdentity
      glLoadIdentity
    end
    private :loadIdentity
  end
end
