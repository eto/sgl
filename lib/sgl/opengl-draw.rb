# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module SGL
  LINES		= OpenGL::GL_LINES
  POINTS	= OpenGL::GL_POINTS
  LINE_STRIP	= OpenGL::GL_LINE_STRIP
  LINE_LOOP	= OpenGL::GL_LINE_LOOP
  TRIANGLES	= OpenGL::GL_TRIANGLES
  TRIANGLE_STRIP = OpenGL::GL_TRIANGLE_STRIP
  TRIANGLE_FAN	= OpenGL::GL_TRIANGLE_FAN
  QUADS		= OpenGL::GL_QUADS
  QUAD_STRIP	= OpenGL::GL_QUAD_STRIP
  POLYGON	= OpenGL::GL_POLYGON

  # draw
  def beginObj(*a)	$__a__.beginObj(*a)	end
  def endObj(*a)	$__a__.endObj(*a)	end
  def push(*a)		$__a__.push(*a)		end
  def pop(*a)		$__a__.pop(*a)		end
  def vertex(*a)	$__a__.vertex(*a)	end
  def normal(*a)	$__a__.normal(*a)	end
  def translate(*a)	$__a__.translate(*a)	end
  def rotateX(*a)	$__a__.rotateX(*a)	end
  def rotateY(*a)	$__a__.rotateY(*a)	end
  def rotateZ(*a)	$__a__.rotateZ(*a)	end
  def scale(*a)		$__a__.scale(*a)	end
  def point(*a)		$__a__.point(*a)	end
  def lineWidth(*a)	$__a__.lineWidth(*a)	end
  def line(*a)		$__a__.line(*a)		end
  def rect(*a)		$__a__.rect(*a)		end
  def triangle(*a)	$__a__.triangle(*a)	end
  def circle(*a)	$__a__.circle(*a)	end
  def box(*a)		$__a__.box(*a)		end
  def cube(*a)		$__a__.cube(*a)		end

  class Application
    LINES	= OpenGL::GL_LINES
    POINTS	= OpenGL::GL_POINTS
    LINE_STRIP	= OpenGL::GL_LINE_STRIP
    LINE_LOOP	= OpenGL::GL_LINE_LOOP
    TRIANGLES	= OpenGL::GL_TRIANGLES
    TRIANGLE_STRIP	= OpenGL::GL_TRIANGLE_STRIP
    TRIANGLE_FAN	= OpenGL::GL_TRIANGLE_FAN
    QUADS	= OpenGL::GL_QUADS
    QUAD_STRIP	= OpenGL::GL_QUAD_STRIP
    POLYGON	= OpenGL::GL_POLYGON

    # draw primitive
    def beginObj(mode = POLYGON)
      glBegin(mode)
    end

    def endObj
      glEnd
    end

    def push
      glPushMatrix
    end

    def pop
      glPopMatrix
    end

    def vertex(a, b = nil, c = nil, d = nil)
      glVertex4f(a, b, c, d) if d
      glVertex3f(a, b, c) if c
      glVertex2f(a, b)
    end

    def normal(a, b = nil, c = nil)
      glNormal(a, b, c)
    end

    # matrix manipulation
    def translate(a, b, c = 0)
      #glTranslate(a, b, c)
      glTranslatef(a, b, c)
    end

    def rotateX(a)
      glRotatef(a, 1, 0, 0)
    end

    def rotateY(a)
      glRotatef(a, 0, 1, 0)
    end

    def rotateZ(a)
      glRotatef(a, 0, 0, 1)
    end

    def scale(a)
      glScalef(a, a, a)
    end

    # simple draw
    def point(a, b, c = nil)
      glBegin(OpenGL::GL_POINTS)
      if c
	glVertex3f(a, b, c)
      else
	glVertex2f(a, b)
      end
      glEnd
    end

    def lineWidth(w)
      glLineWidth(w)
    end

    def line(a, b, c, d, e = nil, f = nil)
      #p [a, b, c, d, e, f]
      glBegin(OpenGL::GL_LINES)
      if e && f
	glVertex3f(a, b, c) # 3D
	glVertex3f(d, e, f)
      else
	glVertex2f(a, b) # 2D
	glVertex2f(c, d)
      end
      glEnd
    end

    def rect(a, b, c, d)
      #glRect(a, b, c, d)
      glRectf(a, b, c, d)
    end

    def triangle(a, b, c, d, e, f)
      glBegin(OpenGL::GL_TRIANGLES)
      glVertex2f(a, b)
      glVertex2f(c, d)
      glVertex2f(e, f)
      glEnd
    end

    def circleUnit(style = LINE_LOOP, div = nil)
      div = 32 if div.nil?
      e = 2 * Math::PI / div
      glBegin(style)
      div.times {|i|
	rad = i * e
	x = Math.cos(rad)
	y = Math.sin(rad)
	glVertex2f(x, y)
      }
      glEnd
    end
    private :circleUnit

    def circle(x, y, r, style = LINE_LOOP, div = nil)
      glPushMatrix
      glTranslate(x, y, 0)
      glScalef(r, r, r)
      circleUnit(style, div)
      glPopMatrix
    end

    def box(x1, y1, z1, x2, y2, z2)
      box = [
	[x1, y1, z1], # 0 back left bottom
	[x2, y1, z1], # 1 back right bottom
	[x2, y2, z1], # 2 back right top
	[x1, y2, z1], # 3 back left top
	[x1, y1, z2], # 4 front left bottom
	[x2, y1, z2], # 5 front right bottom
	[x2, y2, z2], # 6 front right top
	[x1, y2, z2]  # 7 front left top
      ]
      glBegin(OpenGL::GL_QUADS)
      glVertex(box[1]) # back
      glVertex(box[0])
      glVertex(box[3])
      glVertex(box[2])
      glVertex(box[0]) # left
      glVertex(box[4])
      glVertex(box[7])
      glVertex(box[3])
      glVertex(box[4]) # front
      glVertex(box[5])
      glVertex(box[6])
      glVertex(box[7])
      glVertex(box[5]) # right
      glVertex(box[1])
      glVertex(box[2])
      glVertex(box[6])
      glVertex(box[7]) # top
      glVertex(box[6])
      glVertex(box[2])
      glVertex(box[3])
      glVertex(box[0]) # bottom
      glVertex(box[1])
      glVertex(box[5])
      glVertex(box[4])
      glEnd
    end

    def cube(x, y, z, s)
      s = s / 2
      box(x - s, y - s, z - s, x + s, y + s, z + s)
    end
  end

  # This class is not used for now.
  class FasterCircle
    # circle
    def self.circleUnit(style=LINE_LOOP, div=nil)
      div = 32 if div == nil
      e = 2 * Math::PI / div
      beginObj(style)
      div.times {|i|
	rad = i * e
	x = Math.cos(rad)
	y = Math.sin(rad)
	vertex(x, y)
      }
      endObj()
    end

    def self.make_list
      glNewList(1, OpenGL::GL_COMPILE)
      self.circleUnit(LINE_LOOP, 32)
      glEndList()
      glNewList(2, OpenGL::GL_COMPILE)
      self.circleUnit(POLYGON, 32)
      glEndList()
      glNewList(3, OpenGL::GL_COMPILE)
      self.circleUnit(LINE_LOOP, 6)
      glEndList()
      glNewList(4, OpenGL::GL_COMPILE)
      self.circleUnit(POLYGON, 6)
      glEndList()
    end

    def self.circleUnitList(style=LINE_LOOP, div=nil)
      if div == 32
	if style == LINE_LOOP
	  glCallList(1)
	elsif style == POLYGON
	  glCallList(2)
	end
      elsif div == 6
	if style == LINE_LOOP
	  glCallList(3)
	elsif style == POLYGON
	  glCallList(4)
	end
      end
    end

    def self.circle(x, y, r, style=LINE_LOOP, div=nil)
      push()
      translate(x, y)
      scale(r)
      #circleUnit(style, div)
      self.circleUnitList(style, div)
      pop()
    end
  end

end
