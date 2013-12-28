class NSObject

  # http://stackoverflow.com/questions/1461126/getting-array-elements-with-valueforkeypath
  def ValueForKeyPathWithIndexes(fullPath)

    testrange = fullPath.rangeOfString:"["
    return self.valueForKeyPath(fullPath) if testrange.location == NSNotFound

    parts = fullPath.componentsSeparatedByString(".")
    currentObj = self
    parts.each do |part|
      range1 = part.rangeOfString:"["
      if range1.location == NSNotFound          
        currentObj = currentObj.valueForKey(part)
      else
        arrayKey = part.substringToIndex(range1.location)
        index = part.substringToIndex(part.length-1).substringFromIndex(range1.location+1).intValue
        if currentObj.valueForKey(arrayKey).nil?
          nil
        else
          currentObj = currentObj.valueForKey(arrayKey).objectAtIndex(index)
        end
      end
    end
    return currentObj
  end
end