# -*- encoding : utf-8 -*-
require 'multi_json'
require 'nestful'

module Weixin

  class Api

    attr_accessor :api, :key, :access_token, :expired_at, :endpoint

    def initialize(api, key, access_token = nil, expired_at = nil, endpoint = nil)
      self.api = api
      self.key = key
      
      self.access_token = access_token
      self.expired_at   = expired_at
      self.endpoint     = endpoint
    end

    def gw_path(method)
    end

    def gw_url(method)
      "#{endpoint}" + gw_path(method)
    end

    def check_response(response)
      unless response.nil?
        errcode = MultiJson.load(response.body)['errcode']
        return true if errcode == 0
      end
      false
    end

  end

end
