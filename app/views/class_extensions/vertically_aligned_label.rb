VerticalAlignmentTop = 0
VerticalAlignmentMiddle = 1
VerticalAlignmentBottom = 2

class VerticallyAlignedLabel < UILabel
  attr_accessor :verticalAlignment
  
  def initWithFrame(frame)
    if super(frame)
      @verticalAlignment = VerticalAlignmentMiddle
    end
    self
  end

  def setVerticalAlignment(verticalAlignment)
    @verticalAlignment = verticalAlignment
    self.setNeedsDisplay
  end

  def textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
    textRect = super bounds, numberOfLines
    case @verticalAlignment
    when VerticalAlignmentTop
      textRect.origin.y = bounds.origin.y
    when VerticalAlignmentBottom
      textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
    else
      textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0      
    end

    return textRect    
  end

  def drawTextInRect(requestedRect)
    actualRect = textRectForBounds(requestedRect, self.numberOfLines)
    super(actualRect)
  end
end