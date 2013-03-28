微信公众平台 开放消息接口 Rack Middlware
========================================

Latest version: v0.4.0, supports subscribe/unsubscribe event

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
require 'weixin/middleware'
require 'weixin/model'

use Weixin::Middleware, 'your api token', '/your_app_root' 

configure do
    set :wx_id, 'your_weixin_account'
end

helpers do

    def create_message(from, to, type, content, flag=0)
        msg = Weixin::TextReplyMessage.new
        msg.ToUserName = to
        msg.FromUserName = from
        msg.Content = content
        msg.to_xml
    end
end

get '/your_app_root' do
    params[:echostr]
end

post '/your_app_root' do
    content_type :xml, 'charset' => 'utf-8'

    message = request.env[Weixin::Middleware::WEIXIN_MSG]
    logger.info "message: #{request.env[Weixin::Middleware::WEIXIN_MSG_RAW]}"

    from = message.FromUserName
    if message.class == Weixin::EventMessage
        if message.Event == 'subscribe'
            reply_msg_content = "感谢关注！#{reply_msg_content}"
        end
    end

    create_message(settings.wx_id, from, 'text', reply_msg_content)
end
```

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
