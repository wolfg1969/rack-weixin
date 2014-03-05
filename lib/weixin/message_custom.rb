# -*- encoding : utf-8 -*-
require 'multi_json'
require 'nestful'

module Weixin

  class MessageCustom < Api

    def gw_path(method)
      "/message/custom/#{method}?access_token=#{access_token}"
    end

    def send(message)
      response = Nestful::Connection.new(endpoint).post("/cgi-bin#{gw_path('send')}", MultiJson.dump(message)) rescue nil
      check_response(response)
    end

  end

end
