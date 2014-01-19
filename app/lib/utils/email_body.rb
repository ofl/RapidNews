# -*- coding: utf-8 -*-
module RapidNews
  module EmailBody

    def html(bookmarks)
      title = BW::localized_string(:email_html_title, "Todays your bookmarks")
      date = Time.now.strftime("%Y.%m.%d")
      bookmark_list = ''
      bookmarks.each do |bookmark|
        host_name = bookmark.host
        if bookmark.image_url
          image_tag = <<"EOI"
<div style="max-height:110px;overflow:hidden;float:left">
<a href="#{bookmark.link_url}" width="160" align="left" style="font-size:80%;margin:0.5em 1em 0 0" target="_blank">
<img src="#{bookmark.image_url}" width="160" align="left" style="font-size:80%;margin:0.5em 1em 0 0">
</a></div>
EOI
        else
image_tag = ''
        end
        bookmark_list += <<"EOA"
<tr><td valign="top" style="border-bottom:1px solid #ccc"><div style="overflow:hidden;padding:0 0 10px 0">
<p style="margin:5px 0;font-size:100%">
<a href="#{bookmark.link_url}" style="color:#2d5573;text-decoration:none;font-weight:700;line-height:1.4em;font-family:sans-serif;font-size:20px;display:block" target="_blank">
#{bookmark.title}
</a></p>
#{image_tag}
<p style="margin:0.5em 0 0 0;line-height:1.6em;font-family:sans-serif">
#{bookmark.summary}<br>
<span style="float:right;padding-left:5px">
<a href="http://#{host_name}" style="line-height:1.6em;font-family:sans-serif;color:#666" target="_blank">#{host_name}</a>
</span></p></div></td></tr>
EOA
      end

      html =<<"EOF"
<!DOCTYPE html><html><head><meta charset="utf-8"><title>#{title}</title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1"></head><body>
<table cellpadding="0" cellspacing="20" border="0" style="background-image:url()"><tbody><tr><td valign="top">
<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center">
<tbody>
<tr><td valign="middle" align="right" style="line-height:1.6em;font-size:130%;font-family:sans-serif;color:#26323d">#{date}</td></tr>
</tbody></table>
<table cellpadding="0" cellspacing="10" border="0" align="center" style="background-color:#fff!important;border-top:1px solid #ccc;border-left:1px solid #ddd;border-right:1px solid #ccc;border-bottom:1px solid #ddd;margin-top:10px">
<tbody><tr><td>
<p style="border-radius:5px;margin:0 0 0.7em 0;padding:0.5em;line-height:1.2em;background-color:#708090;text-align:center;font-size:100%;font-family:sans-serif;color:#fff">
Your bookmarks<br>by RapidNews.
</p></td></tr>
#{bookmark_list}
<tr><td>
<p style="border-radius:5px;margin:0 0 0.7em 0;padding:0.5em;line-height:1.2em;background-color:#708090;text-align:center;font-size:100%;font-family:sans-serif;color:#fff">
Your bookmarks<br>by RapidNews.
</p></td></tr></tbody></table>
</td></tr></tbody></table>
</body></html>
EOF
      return html
    end

    module_function :html
  end
end
