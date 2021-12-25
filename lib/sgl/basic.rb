# coding: utf-8
# Copyright (C) 2004-2021 Koichiro Eto, All rights reserved.
# License: BSD 3-Clause License

module SGL
  #starttime秒後に始まって、endtime秒後に終る。
  class Timer
    def initialize(st, et)
      @st, @et = st, et
      revert	# 巻き戻し
      count
      @span = (@et - @st).to_f
      #p ['Timer', @bt, @st, @et, @span]
    end
    attr_accessor :st, :et

    # start at 0.0, finished at 1.0
    def ratio
      count
      return 0.0 if @now < @st
      return 1.0 if @et <= @now
      return (@now - @st) / @span
    end

    def started?
      count
      @st <= @now
    end

    def ended?
      count
      @et <= @now
    end

    def start
      @bt += @st if ! started?
      @bt = Time.now.to_f - @st if ! started?
    end

    #begintime→開始時間
    def revert
      @bt = Time.now.to_f
    end

    private

    def count
      @now = Time.now.to_f - @bt
    end
  end

  module Fadeout
    EXISTENCE_TIME = 6 #生存時間
    FADEOUT_TIME = 2   #fadeoutする時間

    def fadeout_initialize
      @timer = Timer.new(EXISTENCE_TIME - FADEOUT_TIME, EXISTENCE_TIME)
    end

    def set_longer_timer
      t = 10
      @timer = Timer.new(EXISTENCE_TIME * t - FADEOUT_TIME * t, EXISTENCE_TIME * t)
    end

    def fadeout
      @timer.start
    end

    def ended?
      @timer.ended?
    end
  end

  class RingArray < Array
    alias get []

    def [](nth)
      nth %= length() if nth < 0 || length() <= nth
      return get(nth)
    end

    def self.test
      t = RingArray.new
      t[0],t[1],t[2] = 0,1,2
      p [t[-3], t[-2], t[-1], t[0], t[1], t[2], t[3], t[4]]
      exit
    end		# RingArray.test

    def randomize!
      # 適当回数入れかえをして、ランダムな並びにする。
      loop {
	a = rand(self.length)
	b = rand(self.length)
	backup = self[a]
	self[a] = self[b]
	self[b] = backup
	break if self.randomized?
      }
    end

    def randomized?
      # 最初にすでにランダム化されていることとする。
      randomized = true
      self.each_index {|i|
	c_1 = self[i-1]
	c   = self[i]
	c1  = self[i+1]
	randomized = false if (c_1 - c).abs <= 2
	randomized = false if (c1  - c).abs <= 2
      }
      return randomized
    end
  end

  class NumSpring
    EPSILON = 0.01

    # 目標となる値、初期値、バネ定数、弾性定数、イプシロン(十分小さい値)
    def initialize(target, initial, ks, kd, e=EPSILON, v=0)
      @target, @initial, @ks, @kd, @e, @v = target, initial, ks, kd, e, v
      @x = @initial
      @moving = true
    end
    attr_reader :x, :target
    attr_accessor :v, :ks, :kd, :moving

    def inspect()
      mov = @moving ? "●" : "○"
      sprintf("[%s%.1f %.1f %.1f %.1f %.1f]", mov, @target, @x, @v, @ks, @kd)
    end

    def target=(num)    @target = num;    @moving = true;  end

    def x=(num)    @x = num;    @moving = true;  end

    def move
      return if ! @moving
      diff = @target - @x
      if diff.abs < @e && @v.abs < @e
	@moving = false
	return
      end
      @v += (diff / @ks)
      @v *= @kd
      @x += @v
    end
  end

  class INumSpring < NumSpring
    # 目標となる値、初期値、バネ定数、弾性定数、イプシロン(十分小さい値)
    def initialize(target, initial, ks, kd, e=EPSILON, v=0)
      super(target, initial, ks, 1.0 - 1.0/kd, e, v) #kdだけinverseする。
    end
  end

  class Spring
    EPSILON = 0.01

    # 目標となる値、初期値、バネ定数、弾性定数、イプシロン(十分小さい値)
    def initialize(target, initial, ks, kd, e=EPSILON, v=0)
      @target, @initial, @ks, @kd, @e, @v = target, initial, ks, kd, e, v
      @x = @initial
      @moving = true
    end
    attr_reader :x, :target
    attr_accessor :v, :ks, :kd

    def inspect()
      mov = @moving ? "●" : "○"
      sprintf("[%s%.1f %.1f %.1f %.1f %.1f]", mov, @target, @x, @v, @ks, @kd)
    end

    def target=(num)    @target = num;    @moving = true;  end

    def x=(num)    @x = num;    @moving = true;  end

    def move
      return if ! @moving
      #if @x.is_a?(Vector)
      if @x.is_a?(V2)
	l = @x - @target
	diff = l.length
	if diff < @e && @v.length < @e
	  @moving = false
	  return
	end
	#fa = -(@ks * diff + @kd * @v)
	ln = l.normalize
	fak = -(@ks * diff + @kd * @v.length)
	fa = ln.scale(fak)
	@v += fa
	@x += @v
	#p ['sp', fa, fak, @v, @x]
      else
	diff = @x - @target
	if diff.abs < @e && @v.abs < @e
	  @moving = false
	  return
	end
	fa = -(@ks * diff + @kd * @v)
	@v += fa
	@x += @v
      end
    end
  end

  class ISpring < Spring
    #目標となる値、初期値、バネ定数、弾性定数、イプシロン(十分小さい値)
    def initialize(target, initial, ks, kd, e=EPSILON, v=0)
      super(target, initial, 1.0/ks, 1.0/kd, e, v) #ksとkdをinverseする。
    end
  end
end
