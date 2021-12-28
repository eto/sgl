#!/usr/bin/env ruby
# coding: utf-8
# Copyright (C) 2004-2021 Koichiro Eto, All rights reserved.
# License: BSD 3-Clause License

require 'fmod'

class FMODSystem
  def initialize
    FMOD.load_library
    @system = FMOD::System.create
  end
  def get_version
  end
  def load_sound(file)
    sound = @system.create_sound("pi.wav")
    fmodsound = FMODSound.new(sound)
    return fmodsound
  end
end

class FMODSound
  def initialize(sound)
    @sound = sound
    @base_note = 60	# 元の音を60として扱う。
    @channel = @note = @volume = @pan = nil
  end
  attr_reader :note
  def length; @sound.length; end
  def play(note = 60, volume = nil, pan = nil)	# MIDI note(0-127, center:60), volume(0-100), pan (left:-100 to right:100)
    @channel = @sound.play
    org_freq = @channel.frequency
    sfreq = midi_note_to_frequency(note) * org_freq / midi_note_to_frequency(@base_note)
    @channel.frequency = sfreq
    @channel.volume = volume if volume
    @channel.pan = pan if pan
  end
  def midi_note_to_frequency(note)
    note = 0   if note < 0
    note = 127 if 127 < note
    return 8.17579891564 * Math.exp(0.0577622650 * note)
  end
  def frequency_to_midi_note(freq)
    return 0 < freq ? 17.3123405046 * Math.log(0.12231220585 * freq) : -1500
  end
end

if __FILE__ == $0
  if ARGV[0] == "--test"
    ARGV.shift
    require "test/unit"
    class TestIt < Test::Unit::TestCase
      def test_it
        assert_equal(2, 1+1)
        it = FMODSound.new(nil)
        assert_equal(2616, (it.midi_note_to_frequency(60)*10).to_i)
        assert_equal(60,   (it.frequency_to_midi_note(261.6)).ceil)
      end
    end
  else
    class App
      def main(argv)
        system = FMODSystem.new
        sound = system.load_sound("pi.wav")
        p sound.length
        (60..90).each {|i|
          sound.play(i)
          sleep 0.04
        }
        sleep 2
      end
    end
    App.new.main(ARGV)
  end
end
