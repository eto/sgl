#!/usr/bin/env ruby -w
# coding: utf-8
# Copyright (C) 2004-2021 Koichiro Eto, All rights reserved.
# License: BSD 3-Clause License

module SGL
  # module control
  def useMidi()		$__a__.useMidi;		end
  def useMidiIn(*a)	$__a__.useMidiIn(*a)	end

  class Application
    def useMidi
      require "sgl/sgl-midi"
      $__midi__ = SGLMidi.new
    end

    def useMidiIn(num = -1)
      require "sgl/sgl-midiin"
      printMidiDeviceNames
      openMidiIn(num)
      startMidiInThread
    end
  end
end
