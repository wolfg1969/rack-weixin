# -*- encoding : utf-8 -*-
require 'multi_json'
require 'nestful'

module Weixin

  class User

    attr_accessor :api, :key, :access_token, :expired_at, :endpoint

    def initialize(api, key, access_token = nil, expired_at = nil, endpoint = nil)
      self.api = api
      self.key = key
      
      self.access_token = access_token
      self.expired_at   = expired_at
      self.endpoint     = endpoint
    end

    def gw_path(method)
      "/user/#{method}?access_token=#{access_token}"
    end

    def gw_url(method)
      "#{endpoint}" + gw_path(method)
    end

    def info(openid, lang = nil)
      url = "#{gw_url('info')}&openid=#{openid}"
      url = "#{url}&lang=#{lang}" if lang.present?

      request = Nestful.get url rescue nil
      MultiJson.load(request.body) unless request.nil?
    end

  end

end
