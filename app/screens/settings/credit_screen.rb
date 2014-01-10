class Settings::CreditScreen < PM::WebScreen

  title 'Credit'

  def will_appear
    @view_is_set_up ||= set_up_view
  end

  def will_disappear
    webview.delegate = nil
    webview.stopLoading
  end

  def set_up_view
    layout(self.view, :base_view)  do
      self.webview.backgroundColor = UIColor.whiteColor
      self.navigationController.navigationBarHidden = false
    end
    true
  end

  def content
return <<'EOF'
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1">
<style type="text/css">
body {
  background-color: #fff;
  width: 90%;
  margin-left: auto;
  margin-right: auto;
  padding-top: 20px;
  padding-bottom: 20px;
  word-wrap: break-word;
  /* font-family: "Hiragino Mincho ProN", serif;*/
  color: #000;
  font-size: 90%;
}

a {
  text-decoration: none;
  color: #000;
  border-bottom: 1px dotted #ccc;
  padding-bottom: 2px;
}

h1 {
  font-size: 120%;
  font-family: sans-serif;
  border-bottom: 1px solid #ccc;
  padding-bottom: 10px;
  margin-bottom: 0;
}

h2, h3, h4 {
  font-family: sans-serif;
}

h2 {
  font-size: 110%;
}

h3, h4 {
  font-size: 100%;
}

div.content {
  margin-top: 3em;
  font-size: 100%;
  line-height: 160%;
}
</style>
</head>
<body>
<h1>クレジット</h1>
</body>
</html>
EOF
  end
end
