require 'roxml'

module Weixin

    class Message
        include ROXML
        xml_name :xml
        xml_convention :camelcase

        xml_reader :to_user_name, :cdata => true
        xml_reader :from_user_name, :cdata => true
        xml_reader :create_time, :as => Integer
        xml_reader :msg_type, :cdata => true
        xml_reader :msg_id, :as => Integer
    end

    class ReplyMessage
        include ROXML
        xml_name :xml
        xml_convention :camelcase

        xml_accessor :to_user_name, :cdata => true
        xml_accessor :from_user_name, :cdata => true
        xml_reader :create_time, :as => Integer
        xml_reader :msg_type, :cdata => true
        xml_accessor :func_flag, :as => Integer

        def initialize
            @create_time = Time.now.to_i
            @func_flag = 0
        end
    end

    class TextMessage < Message
        xml_reader :content, :cdata => true
    end

    class ImageMessage < Message
        xml_reader :pic_url, :cdata => true
    end

    class LocationMessage < Message
        xml_reader :location_x, :as => Float, :from => 'Location_X'
        xml_reader :location_y, :as => Float, :from => 'Location_Y'
        xml_reader :scale, :as => Integer
        xml_reader :label, :cdata => true
    end

    class LinkMessage < Message
        xml_reader :title, :cdata => true
        xml_reader :description, :cdata => true
        xml_reader :url, :cdata => true
    end

    class EventMessage < Message
        xml_reader :event, :cdata => true
        xml_reader :latitude, :as => Float
        xml_reader :longitude, :as => Float
        xml_reader :presision, :as => Float
    end

    class TextReplyMessage < ReplyMessage
        xml_accessor :content, :cdata => true

        def initialize
            super
            @msg_type = 'text'
        end
    end

    class Music
        include ROXML
        xml_convention :camelcase

        xml_accessor :title, :cdata => true
        xml_accessor :description, :cdata => true
        xml_accessor :music_url, :cdata => true
        xml_accessor :hq_music_url, :cdata => true, :from => 'HQMusicUrl'
    end

    class MusicReplyMessage < ReplyMessage
        xml_accessor :music, :as => Music

        def initialize
            super
            @msg_type = 'music'
        end
    end

    class Item
        include ROXML
        xml_convention :camelcase

        xml_accessor :title, :cdata => true
        xml_accessor :description, :cdata => true
        xml_accessor :pic_url, :cdata => true
        xml_accessor :url, :cdata => true
    end

    class NewsReplyMessage < ReplyMessage
        xml_accessor :article_count, :as => Integer
        xml_accessor :articles, :as => [Item], :in => 'Articles', :from => 'Item'

        def initialize
            super
            @msg_type = 'news'
        end
    end
end
