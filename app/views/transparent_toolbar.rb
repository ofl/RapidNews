# "Couldn't UIToolBar be transparent?"
# http://stackoverflow.com/questions/2468831/couldnt-uitoolbar-be-transparent

class TransparentToolbar < UIToolbar
  def drawRect(rect)
  end

  def applyTranslucentBackground
    self.backgroundColor = UIColor.clearColor
    self.opaque = false
    self.translucent = true
  end

  def init
    super.tap {self.applyTranslucentBackground}
  end

  def initWithFrame(frame)
    super.tap {self.applyTranslucentBackground}
  end
end
