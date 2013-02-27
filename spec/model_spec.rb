# -*- encoding : utf-8 -*-
require 'rspec'
require 'weixin/model'

describe 'weixin/model' do

    context 'Weixin:Message' do
        it 'is a text message' do
            msg = Weixin::Message.factory(%(
            <xml>
                <ToUserName><![CDATA[to]]></ToUserName>
                <FromUserName><![CDATA[from]]></FromUserName>
                <CreateTime>1360391199</CreateTime>
                <MsgType><![CDATA[text]]></MsgType>
                <Content><![CDATA[Hello2BizUser]]></Content>
                <MsgId>5842835709471227904</MsgId>
            </xml>
            ))
            msg.class.should == Weixin::TextMessage
            msg.MsgType.should == 'text'
            msg.ToUserName.should == 'to'
            msg.FromUserName.should == 'from'
            msg.CreateTime.should == 1360391199
            msg.Content.should == 'Hello2BizUser'
            msg.MsgId.should == 5842835709471227904
        end

        it 'is a image message' do
            msg = Weixin::Message.factory(%(
            <xml>
                <ToUserName><![CDATA[to]]></ToUserName>
                <FromUserName><![CDATA[from]]></FromUserName>
                <CreateTime>1360391199</CreateTime>
                <MsgType><![CDATA[image]]></MsgType>
                <PicUrl><![CDATA[http://mmsns.qpic.cn/mmsns/Leiaa5NQF4FOTOSo3hXrEsGsodU2jHcWZiaInTxmTh6GaCIJ8hBHicIDA/0]]></PicUrl>
                <MsgId>5842835709471227904</MsgId>
            </xml>
            ))
            msg.class.should == Weixin::ImageMessage
            msg.MsgType.should == 'image'
            msg.ToUserName.should == 'to'
            msg.FromUserName.should == 'from'
            msg.CreateTime.should == 1360391199
            msg.MsgId.should == 5842835709471227904
            msg.PicUrl.should_not nil
        end

        it 'is a location message' do
            msg = Weixin::Message.factory(%(
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
            msg.class.should == Weixin::LocationMessage
            msg.MsgType.should == 'location'
            msg.ToUserName.should == 'to'
            msg.FromUserName.should == 'from'
            msg.CreateTime.should == 1360391199
            msg.MsgId.should == 5842835709471227904
            msg.Label.should_not nil
            msg.Scale.should == 15
            msg.Location_X.should == 69.866013
            msg.Location_Y.should == 136.269449
        end

    end

    context 'Weixin::ReplyMessage' do

        it 'is a text reply message' do
            msg = Weixin::TextReplyMessage.new
            msg.ToUserName = 'to'
            msg.FromUserName = 'from'
            msg.Content = 'blah'
            msg.MsgType.should == 'text'
        end

        it 'is a news reply message' do
            msg = Weixin::NewsReplyMessage.new
            msg.ToUserName = 'to'
            msg.FromUserName = 'from'
            item1 = Weixin::Item.new
            item1.Title = 'title1'
            item1.Description = 'blah'
            item2 = Weixin::Item.new
            item2.Title = 'title2'
            item2.Description = 'blah blah'
            msg.Articles = [item1, item2]
            msg.ArticleCount = 2
            msg.MsgType.should == 'news'
            #puts msg.to_xml
        end

    end

end
