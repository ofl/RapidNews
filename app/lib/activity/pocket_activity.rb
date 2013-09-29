# -*- coding: utf-8 -*-
class PocketActivity < UIActivity
  include URLPerformable

  def activityType
    "net.bloghackers.app.PocketActivity"
  end

  def activityImage
    UIImage.imageNamed("images/NNPocketActivity") # borrowed from NNNetwork (https://github.com/tomazsh/NNNetwork)
  end

  def activityTitle
    "Pocket"
  end

  def performActivity
    SVProgressHUD.showWithStatus("保存中...")
    PocketAPI.sharedAPI.saveURL(@url, handler: -> (api, url, error) do
        if error
          SVProgressHUD.showErrorWithStatus(error.localizedDescription)
        else
          SVProgressHUD.showSuccessWithStatus("保存しました")
        end
      end
    )
    activityDidFinish(true)
  end
end