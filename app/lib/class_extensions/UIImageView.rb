class UIImageView
  def self.cacheImageWithURL(url)
    request = NSMutableURLRequest.requestWithURL(url, 
                                                 cachePolicy: NSURLRequestUseProtocolCachePolicy,
                                                 timeoutInterval: 30.0)
    request.setHTTPShouldHandleCookies(false)
    request.setHTTPShouldUsePipelining(true)

    requestOperation = AFImageRequestOperation.alloc.initWithRequest(request)
    requestOperation.setCompletionBlockWithSuccess(-> (operation, responseObject) {
                                                     self.af_sharedImageCache.cacheImage(responseObject, 
                                                                                         forRequest: request)
                                                   },
                                                   failure: -> (operation, error) {p 'failed to image cache'})
    requestOperation.start
  end
end
