require 'roxml'

module Weixin

    class Message
        include ROXML
        
        xml_name :xml
        xml_convention :camelcase

        xml_accessor :to_user_name, :cdata => true
        xml_accessor :from_user_name, :cdata => true
        xml_accessor :create_time, :as => Integer
        xml_accessor :msg_type, :cdata => true
        xml_accessor :msg_id, :as => Integer
    end

    class TextMessage < Message
        xml_accessor :content, :cdata => true
    end

    class ImageMessage < Message
        xml_accessor :pic_url, :cdata => true
    end

    class LocationMessage < Message
        xml_accessor :location_x, :as => Float, :from => 'Location_X'
        xml_accessor :location_y, :as => Float, :from => 'Location_Y'
        xml_accessor :scale, :as => Integer
        xml_accessor :label, :cdata => true
    end

    class LinkMessage < Message
        xml_accessor :title, :cdata => true
        xml_accessor :description, :cdata => true
        xml_accessor :url, :cdata => true
    end
end
