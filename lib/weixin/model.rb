# -*- encoding : utf-8 -*-
require 'roxml'
require 'multi_xml'
require 'ostruct'

module Weixin

    class Message

        def initialize(hash)
            @source = OpenStruct.new(hash) 
        end

        def method_missing(method, *args, &block)
            @source.send(method, *args, &block)
        end

        def CreateTime
            @source.CreateTime.to_i
        end

        def MsgId
            @source.MsgId.to_i
        end

        def Message.factory(xml)
            hash = MultiXml.parse(xml)['xml']
            case hash['MsgType']
            when 'text'
                TextMessage.new(hash)
            when 'image'
                ImageMessage.new(hash)
            when 'location'
                LocationMessage.new(hash)
            when 'link'
                LinkMessage.new(hash)
            when 'event'
                EventMessage.new(hash)
            when 'voice'
                VoiceMessage.new(hash)
            when 'video'
                VideoMessage.new(hash)
            else
                raise ArgumentError, 'Unknown Message'
            end
        end

    end

    # <xml>
    #     <ToUserName><![CDATA[toUser]]></ToUserName>
    #     <FromUserName><![CDATA[fromUser]]></FromUserName> 
    #     <CreateTime>1348831860</CreateTime>
    #     <MsgType><![CDATA[text]]></MsgType>
    #     <Content><![CDATA[this is a test]]></Content>
    #     <MsgId>1234567890123456</MsgId>
    # </xml>
    TextMessage = Class.new(Message)
    
    # <xml>
    #     <ToUserName><![CDATA[toUser]]></ToUserName>
    #     <FromUserName><![CDATA[fromUser]]></FromUserName>
    #     <CreateTime>1348831860</CreateTime>
    #     <MsgType><![CDATA[image]]></MsgType>
    #     <PicUrl><![CDATA[this is a url]]></PicUrl>
    #     <MsgId>1234567890123456</MsgId>
    # </xml>
    ImageMessage = Class.new(Message)
    
    # <xml>
    #   <ToUserName><![CDATA[toUser]]></ToUserName>
    #   <FromUserName><![CDATA[fromUser]]></FromUserName>
    #   <CreateTime>1351776360</CreateTime>
    #   <MsgType><![CDATA[link]]></MsgType>
    #   <Title><![CDATA[公众平台官网链接]]></Title>
    #   <Description><![CDATA[公众平台官网链接]]></Description>
    #   <Url><![CDATA[url]]></Url>
    #   <MsgId>1234567890123456</MsgId>
    # </xml> 
    LinkMessage = Class.new(Message)
    
    # <xml>
    #     <ToUserName><![CDATA[toUser]]></ToUserName>
    #     <FromUserName><![CDATA[FromUser]]></FromUserName>
    #     <CreateTime>123456789</CreateTime>
    #     <MsgType><![CDATA[event]]></MsgType>
    #     <Event><![CDATA[EVENT]]></Event>
    #     <EventKey><![CDATA[EVENTKEY]]></EventKey>
    # </xml>
    EventMessage = Class.new(Message)

    # <xml>
    #     <ToUserName><![CDATA[toUser]]></ToUserName>
    #     <FromUserName><![CDATA[fromUser]]></FromUserName>
    #     <CreateTime>1351776360</CreateTime>
    #     <MsgType><![CDATA[location]]></MsgType>
    #     <Location_X>23.134521</Location_X>
    #     <Location_Y>113.358803</Location_Y>
    #     <Scale>20</Scale>
    #     <Label><![CDATA[位置信息]]></Label>
    #     <MsgId>1234567890123456</MsgId>
    # </xml> 
    class LocationMessage < Message

        def Location_X
            @source.Location_X.to_f
        end

        def Location_Y
            @source.Location_Y.to_f
        end

        def Scale
            @source.Scale.to_i
        end
    end

    # <xml>
    #   <ToUserName><![CDATA[toUser]]></ToUserName>
    #   <FromUserName><![CDATA[fromUser]]></FromUserName>
    #   <CreateTime>1376632760</CreateTime>
    #   <MsgType><![CDATA[voice]]></MsgType>
    #   <MediaId><![CDATA[Qyb0tgux6QLjhL6ipvFZJ-kUt2tcQtkn0BU365Vt3wUAtqfGam4QpZU35RXVhv6G]]></MediaId>
    #   <Format><![CDATA[amr]]></Format>
    #   <MsgId>5912592682802219078</MsgId>
    #   <Recognition><![CDATA[]]></Recognition>
    # </xml>
    class VoiceMessage < Message

        def MediaId
            @source.MediaId
        end

        def Format
            @source.Format
        end
    end


    # <xml>
    #   <ToUserName><![CDATA[toUser]]></ToUserName>
    #   <FromUserName><![CDATA[fromUser]]></FromUserName>
    #   <CreateTime>1376632994</CreateTime>
    #   <MsgType><![CDATA[video]]></MsgType>
    #   <MediaId><![CDATA[TAAGb6iS5LcZR1d5ICiZTWGWi6-Upic9tlWDpAKcNJA]]></MediaId>
    #   <ThumbMediaId><![CDATA[U-xulPW4kq6KKMWFNaBSPc65Bcgr7Qopwex0DfCeyQs]]></ThumbMediaId>
    #   <MsgId>5912593687824566343</MsgId>
    # </xml>
    class VideoMessage < Message

        def MediaId
            @source.MediaId
        end

        def ThumbMediaId
            @source.ThumbMediaId
        end
    end

    class ReplyMessage
        include ROXML
        xml_name :xml
        #xml_convention :camelcase

        xml_accessor :ToUserName, :cdata => true
        xml_accessor :FromUserName, :cdata => true
        xml_reader :CreateTime, :as => Integer
        xml_reader :MsgType, :cdata => true

        def initialize
            @CreateTime = Time.now.to_i
        end

        def to_xml
           super.to_xml(:encoding => 'UTF-8', :indent => 0, :save_with => 0)
        end
    end

    class TextReplyMessage < ReplyMessage
        xml_accessor :Content, :cdata => true

        def initialize
            super
            @MsgType = 'text'
        end
    end

    class Music
        include ROXML

        xml_accessor :Title, :cdata => true
        xml_accessor :Description, :cdata => true
        xml_accessor :MusicUrl, :cdata => true
        xml_accessor :HQMusicUrl, :cdata => true
    end

    class MusicReplyMessage < ReplyMessage
        xml_accessor :Music, :as => Music

        def initialize
            super
            @MsgType = 'music'
        end
    end

    class Item
        include ROXML

        xml_accessor :Title, :cdata => true
        xml_accessor :Description, :cdata => true
        xml_accessor :PicUrl, :cdata => true
        xml_accessor :Url, :cdata => true
    end

    class NewsReplyMessage < ReplyMessage
        xml_accessor :ArticleCount, :as => Integer
        xml_accessor :Articles, :as => [Item], :in => 'Articles', :from => 'item'

        def initialize
            super
            @MsgType = 'news'
        end
    end
end
