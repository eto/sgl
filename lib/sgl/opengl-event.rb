# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module SGL
  # callback functions
#  def setup()		end
#  def onMouseDown(x,y)	end
#  def onMouseUp(x,y)	end
#  def onKeyDown(k)	end
#  def onKeyUp(k)	end
#  def display()		end

  # callback functions for fullscreen
#  def onMouseDown0(x,y)	end
#  def display0()	end

  # mainloop
  def at_exit
    mainloop
  end

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
      qp Object.private_methods(false) - $test_basic_private_methods
      #$__a__.mainloop
      #qp private_methods(false) - $test_basic_private_methods
      #qp Object.private_methods(false) - $test_basic_private_methods
      #qp $basic_private_methods
      #qp Object.private_methods(false)
      #qp Object.private_methods(false) - $basic_private_methods
      #qp private_methods(false) - $basic_private_methods

      $__a__.mainloop_setup
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
  def flip(*a)	$__a__.flip(*a)	end
  def wait(*a)	$__a__.wait(*a)	end
  def process(&b)	$__a__.process(&b)	end

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

  class Application
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
  end
end
