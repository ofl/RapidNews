class UIImage

  # http://robots.thoughtbot.com/post/46668544473/designing-for-ios-blending-modes
  def tintedImageWithColor(tintColor)
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
    tintColor.setFill
    bounds = CGRectMake(0, 0, self.size.width, self.size.height)
    UIRectFill(bounds)
    self.drawInRect(bounds, blendMode: KCGBlendModeDestinationIn, alpha:1.0)
    tintedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return tintedImage
  end
end