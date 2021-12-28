#!/usr/bin/env ruby -w
# coding: utf-8
# Copyright (C) 2004-2021 Koichiro Eto, All rights reserved.
# License: BSD 3-Clause License

#require 'sgl/bass'
require 'sgl/fmod'

module SGL
  def useSound()	$__a__.useSound;	end
  def loadSound(*a)	$__a__.loadSound(*a)	end
  def stopSound(*a)	$__a__.stopAll(*a)	end
  class Application
    def useSound; @sound_system = FMODSystem.new; end
    def loadSound(file); return @sound_system.load_sound(file); end
    def stopSound; end	#Bass::BassLib.instance.stop_all
  end
end
