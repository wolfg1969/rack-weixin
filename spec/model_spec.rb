require 'rspec'
require 'weixin/model'

describe 'weixin/model' do

    context 'Weixin:Message' do
        it 'is a text message' do
            msg = Weixin::TextMessage.from_xml(%(
            <xml>
                <ToUserName><![CDATA[to]]></ToUserName>
                <FromUserName><![CDATA[from]]></FromUserName>
                <CreateTime>1360391199</CreateTime>
                <MsgType><![CDATA[text]]></MsgType>
                <Content><![CDATA[Hello2BizUser]]></Content>
                <MsgId>5842835709471227904</MsgId>
            </xml>
            ))
            msg.msg_type.should == 'text'
            msg.to_user_name.should == 'to'
            msg.from_user_name.should == 'from'
            msg.create_time.should == 1360391199
            msg.content.should == 'Hello2BizUser'
            msg.msg_id.should == 5842835709471227904
        end

        it 'is a image message' do
            msg = Weixin::ImageMessage.from_xml(%(
            <xml>
                <ToUserName><![CDATA[to]]></ToUserName>
                <FromUserName><![CDATA[from]]></FromUserName>
                <CreateTime>1360391199</CreateTime>
                <MsgType><![CDATA[image]]></MsgType>
                <PicUrl><![CDATA[http://mmsns.qpic.cn/mmsns/Leiaa5NQF4FOTOSo3hXrEsGsodU2jHcWZiaInTxmTh6GaCIJ8hBHicIDA/0]]></PicUrl>
                <MsgId>5842835709471227904</MsgId>
            </xml>
            ))
            msg.msg_type.should == 'image'
            msg.to_user_name.should == 'to'
            msg.from_user_name.should == 'from'
            msg.create_time.should == 1360391199
            msg.msg_id.should == 5842835709471227904
            msg.pic_url.should_not nil
        end

        it 'is a location message' do
            msg = Weixin::LocationMessage.from_xml(%(
            <xml>
                <ToUserName><![CDATA[to]]></ToUserName>
                <FromUserName><![CDATA[from]]></FromUserName>
                <CreateTime>1360391199</CreateTime>
                <MsgType><![CDATA[location]]></MsgType>
                <Location_X>69.866013</Location_X>
                <Location_Y>136.269449</Location_Y>
                <Scale>15</Scale>
                <Label><![CDATA[somewhere]]></Label>
                <MsgId>5842835709471227904</MsgId>
            </xml>
            ))
            msg.msg_type.should == 'location'
            msg.to_user_name.should == 'to'
            msg.from_user_name.should == 'from'
            msg.create_time.should == 1360391199
            msg.msg_id.should == 5842835709471227904
            msg.label.should_not nil
            msg.scale.should == 15
            msg.location_x.should == 69.866013
            msg.location_y.should == 136.269449
        end

    end

    context 'Weixin::ReplyMessage' do

        it 'is a text reply message' do
            msg = Weixin::TextReplyMessage.new
            msg.to_user_name = 'to'
            msg.from_user_name = 'from'
            msg.content = 'blah'
            msg.msg_type.should == 'text'
        end

        it 'is a news reply message' do
            msg = Weixin::NewsReplyMessage.new
            msg.to_user_name = 'to'
            msg.from_user_name = 'from'
            item1 = Weixin::Item.new
            item1.title = 'title1'
            item1.description = 'blah'
            item2 = Weixin::Item.new
            item2.title = 'title2'
            item2.description = 'blah blah'
            msg.articles = [item1, item2]
            msg.article_count = 2
            msg.msg_type.should == 'news'
            #puts msg.to_xml
        end

    end

end
