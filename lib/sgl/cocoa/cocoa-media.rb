#!/usr/bin/env ruby -w
# coding: utf-8
# Copyright (C) 2004-2021 Koichiro Eto, All rights reserved.
# License: BSD 3-Clause License

#require "kconv"

module SGL
  class Application
    # handle multimedia data
    def movie(u)
      if /\Ahttp:\/\// =~ u || /\Artsp:\/\// =~ u
	url = Cocoa::NSURL.URLWithString_(u)
      else
	url = Cocoa::NSURL.fileURLWithPath_(u)
      end
      mov = Cocoa::NSMovie.alloc.initWithURL(url, :byReference, true)
      # Place the movie on the out of screen.
      obj = NSMovieView.alloc.initWithFrame([-100.0, -100.0, 10.0, 10.0])
      obj.setApp(self)
      obj.setMovie(mov)
      obj.showController(false, :adjustingSize, false)
      view = @options[:movie] ? @movview : @bgview
      # This "p" is needed to show the movie. I don't know why.
      p [@options[:movie], view]
      #p view # This does not work.
      #dummy = view.inspect # This does not work.
      view.addSubview(obj)
      obj
    end

    def image(file)
      img = NSImage.alloc.initWithContentsOfFile(file)
      img.setApp(self)
      img
    end

    def font(*a)
      NSFont.new(self, *a)
    end

    def sound(file)
      url = Cocoa::NSURL.fileURLWithPath_(file)
      snd = NSSound.alloc.initWithContentsOfURL(url, :byReference, true)
      snd
    end
  end

=begin
  #class NSMovieView < Cocoa::NSMovieView
  class NSMovieView < Cocoa::NSMovieView
    include FrameTranslator

    def setApp(app)
      @app = app
      @playing = false
    end

    def rect(a,b,c,d)
      frame(*to_xywh(a, b, c, d))
      #frame(*@app.to_xywh(a, b, c, d))
    end

    def frame(a,b,c,d)
      setFrame([a, b, c, d])
    end

    def play
      return if @playing
      @playing = true
      start_
    end

    def stop
      return if ! @playing
      @playing = false
      stop_
    end

    def goBegin()	gotoBeginning_;	end
    def goEnd()	gotoEnd_;	end
    def forward()	stepForward_;	end
    def back()	stepBack_;	end
    def loop=(a)	setLoopMode(a);	end
    def rate=(r)	setRate(r/100.0);	end
    def volume=(v)	setVolume(v/100.0);	end
  end

  class NSImage < Cocoa::NSImage
    include FrameTranslator

    def setApp(app)	@app = app;	end

    def rect(a,b,c,d)
      frame(*to_xywh(a, b, c, d))
    end

    def frame(x,y,w,h)
      drawInRect([x,y,w,h],
		 :fromRect, [0,0,size.width,size.height],
		 :operation, Cocoa::NSCompositeSourceOver,
		 :fraction, @app.curcolor[3])
    end
  end
=end

  class NSFont
    def initialize(w, n="Helvetica", s=0.0)
      @app, @name, @size = w, n, s.abs
    end
    attr_accessor :name
    attr_reader :size

    def size=(s)
      @size = s.abs
    end

    def text(x, y, str)
      return unless str.is_a? String
      str = NKF.nkf("-m0 -s", str)
      str = Cocoa::NSMutableAttributedString.alloc.initWithString(str)
      str.addAttribute(Cocoa::NSFontAttributeName(),
		       :value, Cocoa::NSFont.fontWithName(@name, :size, @size),
		       :range, [0,str.length])
      color = @app.color_cur
      str.addAttribute(Cocoa::NSForegroundColorAttributeName(),
		       :value, color,
		       :range, [0,str.length])
      str.drawAtPoint([x, y])
    end

    def show_fixed()	show(Cocoa::NSFixedPitchFontMask);	end
    def show_all()	show;	end

    private
    def show(mask=0)
      fmgr = Cocoa::NSFontManager.sharedFontManager
      fonts = fmgr.availableFontNamesWithTraits(mask).to_a.map{|i| i.to_s }.sort
      puts fonts
    end
  end

  class NSSound < Cocoa::NSSound
  end
end
