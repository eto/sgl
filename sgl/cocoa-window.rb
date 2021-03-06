# Copyright (c) 2004-2020, Koichiro Eto, All rights reserved.
# See LICENSE

module SGL
  class Application
    def cocoa_create_window(w, h)
      @receiver = CocoaReceiver.alloc.init
      @receiver.setApp(self)

      # create a window
      s = Cocoa::NSScreen.mainScreen.frame.size
      x = (s.width  - w) / 2.0
      y = (s.height - h) / 2.0
      win_frame = [x.to_f, y.to_f, w.to_f, h.to_f]
      style = Cocoa::NSClosableWindowMask
      style |= @options[:border] ? Cocoa::NSTitledWindowMask :
	         Cocoa::NSBorderlessWindowMask
      rect = Cocoa::NSRect.new(x: win_frame[0], y: win_frame[1], width: win_frame[2], height: win_frame[3])
      win = Cocoa::NSWindow.alloc.initWithContentRect(Cocoa::NSRect.new(x: 0, y: 0, width: 250, height: 100),
                                                      styleMask: Cocoa::NSTitledWindowMask | Cocoa::NSClosableWindowMask | Cocoa::NSMiniaturizableWindowMask,
                                                      backing: Cocoa::NSBackingStoreBuffered,
                                                      defer: false).autorelease
#      win = Cocoa::NSWindow.alloc.initWithContentRect(rect,
#			                              :styleMask, style,
#			                              :backing, Cocoa::NSBackingStoreBuffered,
#			                              :defer, true)
      win.setTitle("sgl")

      # create a view
      view = SglNSView.alloc.init
      view.setApp(self)
      win.setContentView(view)
      background(100)	# white
      color(0)		# black

      # for handling windowShouldClose
      win.setDelegate(@receiver)
      win.setOpaque(false)	# can be transparent
      win.setHasShadow(@options[:shadow])
      win.setReleasedWhenClosed(false)
      win.makeKeyAndOrderFront(@receiver)
      win.orderFrontRegardless	# show the window now
      @win = win
      @bgview = view
      window_movie(@options) if @options[:movie]
     #window_overlay(@options) if defined?(displayOverlay)
      window_overlay(@options) if @options[:overlay]
      @win
    end

    # sub view
    def window_movie(options)
      @movwin, @movview = make_view(@win, @bgview, NSViewForMovie, @options)
      @win.addChildWindow(@movwin, :ordered, Cocoa::NSWindowAbove)
      @movview.setNeedsDisplay(true)
      @movwin
    end

    def window_overlay(options)
      @owin, @oview = make_view(@win, @bgview, NSViewForOverlay, options)
      win = options[:movie] ? @movwin : @win
      win.addChildWindow(@owin, :ordered, Cocoa::NSWindowAbove)
      @oview.setNeedsDisplay(true)
      @owin
    end

    def make_view(parent_win, parent_view, viewclass, options)
      o = parent_view.frame.origin
      so = parent_win.convertBaseToScreen([o.x, o.y])
      s = parent_view.frame.size
      win_frame = [so.x, so.y, s.width, s.height]
      rect = Cocoa::NSRect.new(x: win_frame[0], y: win_frame[1], width: win_frame[2], height: win_frame[3])
      win = Cocoa::NSWindow.alloc.initWithContentRect(rect,
			    :styleMask, Cocoa::NSBorderlessWindowMask,
			    :backing, Cocoa::NSBackingStoreBuffered,
			    :defer, true)
      win.setOpaque(false)	# can be transparent
      win.setHasShadow(false)
      win.setIgnoresMouseEvents(true)
      win.setAlphaValue(1.0)	# transparent
      b = parent_view.bounds
      bo, bs = b.origin, b.size
      frame = [bo.x, bo.y, bs.width, bs.height]
      view = viewclass.alloc.initWithFrame(frame)
      view.setApp(self)
      win.contentView.addSubview(view)
      win.orderFront(@receiver)
      return win, view
    end
    private :window_movie, :window_overlay, :make_view

    # Cocoa callback methods
    def window_should_close
      stop
    end
  end

  class CocoaReceiver < Cocoa::NSObject
    def init
      @app = nil
      return self
    end

    def setApp(app)
      @app = app
    end

    # Cocoa callback methods
    def windowShouldClose(sender)
      @app.window_should_close
    end
  end

  class NSWindow < Cocoa::NSWindow
  end

  # Do not use NSView for class name.
  # It causes Illeagal Instruction Error.
  # I don't know why.
  class SglNSView < Cocoa::NSView
#    ns_overrides :drawRect_,
#      :mouseDown_, :mouseDragged_, :mouseUp_, :keyDown_, :keyUp_
    def setApp(app)
      @app = app
    end

    def drawRect(rect)
      @app.display_all(rect)
    end

    def mouseDown(event)
      @app.do_mousedown
    end

    def mouseDragged(event) # ignore
    end

    def mouseUp(event)
      @app.do_mouseup
    end

    def keyDown(event)
      @app.do_keydown(event)
    end

    def keyUp(event)
      @app.do_keyup(event)
    end
  end

  class NSViewForOverlay < Cocoa::NSView
#    ns_overrides :drawRect_
    def setApp(app)	@app = app;	end
    def drawRect(rect)	@app.display_overlay_all(rect);	end
  end

  class NSViewForMovie < Cocoa::NSView
#    ns_overrides :drawRect_
    def setApp(app)	@app = app;	end
    def drawRect(rect)	@app.display_mov(rect);	end
  end
end
