微信公众平台 开放消息接口 Rack Middleware
========================================

Latest version: v0.4.0.1, supports subscribe/unsubscribe event

* 验证微信请求 with 'weixin/middleware'
* 解析推送消息 with 'weixin/model'
* 生成回复消息 with 'weixin/model'


Installation
------------
```
$ gem install rack-weixin
```


Usage
-----

A sinatra demo

```ruby
# -*- encoding : utf-8 -*-
require 'sinatra'
require 'rack-weixin'

use Weixin::Middleware, 'your api token', '/your_app_root' 

configure do
    set :wx_id, 'your_weixin_account'
end

helpers do
  def text_parse(msg)
    case msg.Content
    when '我想听歌'
      mp3 = Weixin.music(
        '身骑白马',
        '徐佳莹首张专辑《LALA创作专辑》的主打歌。这首歌的是由徐佳莹及其老师苏通达共同创作，其最大的特点是改编自台湾的民间剧种歌仔戏。',
        'http://nj.baidupcs.com/file/9cbb087ece3da309a31e05a7e14003c9?xcode=70d27743259294de1c42dff2d4720c05d4c19cd5e52a44f7&fid=204864837-250528-3177081425&time=1376666534&sign=FDTAXER-DCb740ccc5511e5e8fedcff06b081203-9NqxJyKhTJYx34SlHyPnK7%2B83vY%3D&to=nb&fm=B,B,T&expires=8h&rt=sh&r=756751042&logid=2171432620&sh=1&fn=%E8%BA%AB%E9%AA%91%E7%99%BD%E9%A9%AC.mp3',
        'http://nj.baidupcs.com/file/9cbb087ece3da309a31e05a7e14003c9?xcode=c59d095c8566efe4d948c3846269e02ed4c19cd5e52a44f7&fid=204864837-250528-3177081425&time=1376666631&sign=FDTAXER-DCb740ccc5511e5e8fedcff06b081203-yAO3TLeuAQ867emfUs0dYKgMtSE%3D&to=nb&fm=B,B,T&expires=8h&rt=sh&r=897038653&logid=4061975287&sh=1&fn=%E8%BA%AB%E9%AA%91%E7%99%BD%E9%A9%AC.mp3'
      )
      Weixin.music_msg(msg.ToUserName, msg.FromUserName, mp3)
    else
      Weixin.text_msg(msg.ToUserName, msg.FromUserName, '这件商品暂时缺货~~')
    end
  end

  def image_parse(msg)
    item = Weixin.item(
      '发现一个基于sinatra的web框架padrino',
      'gem install padrino
      padrino g project myapp -d datamapper -b
      cd myapp
      padrino g admin
      padrino rake dm:migrate seed
      padrino start',
      'http://www.padrinorb.com/images/screens.jpg',
      'http://www.padrinorb.com/'
    )
    Weixin.news_msg(msg.ToUserName, msg.FromUserName, [item])
  end

  def location_parse(msg)
    "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{msg.Location_X},#{msg.Location_Y}"
    Weixin.text_msg(msg.ToUserName, msg.FromUserName, "#{msg.Label} 周围没有妹子~")
  end

  def link_parse(msg)
    # Mechanize.new.get(msg.Url) # 爬虫
    Weixin.text_msg(msg.ToUserName, msg.FromUserName, '这件商品暂时缺货~~')
  end

  def event_parse(msg)
    case msg.Event
    when 'subscribe' # 订阅
      Weixin.text_msg(msg.ToUserName, msg.FromUserName, '欢迎订阅【数字尾巴】~~')
    when 'unsubscribe' # 退订
      # 又少了名用户
    when 'CLICK' # 点击菜单
      menu_parse(msg)
    else
      Weixin.text_msg(msg.ToUserName, msg.FromUserName, '作为一名程序猿，表示压力山大~~')
    end
  end

  def menu_parse(msg)
    case msg.EventKey
    when 'profile'
      # ???
      Weixin.text_msg(msg.ToUserName, msg.FromUserName, '主人您的个人信息丢失啦~')
    else
      Weixin.text_msg(msg.ToUserName, msg.FromUserName, '您想来点什么？')
    end 
  end

  def msg_router(msg)
    case msg.MsgType
    when 'text'
      text_parse(msg)
    when 'image'
      image_parse(msg)
    when 'location'
      location_parse(msg)
    when 'link'
      link_parse(msg)
    when 'event'
      event_parse(msg)
    when 'voice'
      voice_parse(msg)
    when 'video'
      video_parse(msg)
    else
      Weixin.text_msg(msg.ToUserName, msg.FromUserName, '作为一名程序猿，表示压力山大~~')
    end
  end
end

get '/your_app_root' do
    params[:echostr]
end

post '/your_app_root' do
    content_type :xml, 'charset' => 'utf-8'

    message = request.env[Weixin::Middleware::WEIXIN_MSG]
    logger.info "原始数据: #{request.env[Weixin::Middleware::WEIXIN_MSG_RAW]}"
    msg_router(message) unless message.nil?
end
```

### Padrino下使用
在`Gemfile`里加入:

	gem 'rack-weixin'

在`config/apps.rb`关闭以下两个：

	set :protection, false
	set :protect_from_csrf, false
	
在`app.rb`里加入：

	use Weixin::Middleware, 'your api token', '/your_app_root' 

	configure do
    	set :wx_id, 'your_weixin_account'
	end



TODO
----

Copyright
---------

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
