#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require File.dirname(__FILE__) + '/test_helper.rb'
require 'sgl/bass'

class TestBass < Test::Unit::TestCase
  TEST_FILENAME = "c:/WINDOWS/Media/start.wav"

  def test_0_simple_play
    bass = Bass::BassLib.instance
    samp = Bass::Sample.new(TEST_FILENAME)

    # test_play
    samp.play; sleep 0.05

    # test_note
    [0, 2, 4, 5, 7, 9, 11, 12].each {|n| samp.play(60 + n); sleep 0.05 }

    # test_volume
    10.times {|v| samp.play(60, v * 10); sleep 0.05 }

    # test_pan
    10.times {|pos| samp.play(60, 100, pos * 20 - 100); sleep 0.05 }
  end

  def where(name)
    ENV['PATH'].split(';').each {|d|
      pa = Pathname.new d
      if pa.exist?
	Dir.chdir pa
	puts pa
	system "ls *#{name}*"
      end
    }
  end

  def notuse_test_bass_version
    require 'pathname'
    require 'test/unit'
    require 'Win32API'

    puts [RUBY_VERSION, RUBY_PLATFORM, RUBY_RELEASE_DATE].join ' '
    where('bass')

    bass_getversion = Win32API.new('bass', 'BASS_GetVersion', 'V', 'L')
    # "0.6.1"
    # "2.3.3"
    ver = bass_getversion.call
    printf("%x\n", ver)
    major = (ver >> 24) & 0xff
    minor = (ver >> 16) & 0xff
    revision = ver & 0xffff
    p "#{major}.#{minor}.#{revision}"
  end
end
