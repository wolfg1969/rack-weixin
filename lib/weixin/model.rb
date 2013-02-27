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
            else
                raise ArgumentError, 'Unknown Message'
            end
        end

    end

    TextMessage = Class.new(Message)
    ImageMessage = Class.new(Message)
    LinkMessage = Class.new(Message)

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

    class EventMessage < Message
        
        def Latitude
            @source.Latitude.to_f
        end

        def Longitude
            @source.Longitude.to_f
        end

        def Precision
            @source.Precision.to_f
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
        xml_accessor :FuncFlag, :as => Integer

        def initialize
            @CreateTime = Time.now.to_i
            @FuncFlag = 0
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
        xml_accessor :Articles, :as => [Item], :in => 'Articles', :from => 'Item'

        def initialize
            super
            @MsgType = 'news'
        end
    end
end
