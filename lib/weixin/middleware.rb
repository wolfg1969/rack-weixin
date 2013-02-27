# -*- encoding : utf-8 -*-
require 'digest/sha1'

module Weixin

    class Middleware

        POST_BODY       = 'rack.input'.freeze
        WEIXIN_MSG      = 'weixin.msg'.freeze
        WEIXIN_MSG_RAW  = 'weixin.msg.raw'.freeze

        def initialize(app, app_token, path)
            @app = app
            @app_token = app_token
            @path = path
        end

        def call(env)
            dup._call(env)
        end

        def _call(env)
            if @path == env['PATH_INFO'].to_s && ['GET', 'POST'].include?(env['REQUEST_METHOD'])

                @req = Rack::Request.new(env)
                return invalid_request! unless request_is_valid?
                return [
                    200, 
                    { 'Content-type' => 'text/plain', 'Content-length' => @req.params['echostr'].length.to_s }, 
                    [ @req.params['echostr'] ]
                ] if @req.get?

                raw_msg = env[POST_BODY].read
                begin
                    env.update WEIXIN_MSG => Weixin::Message.factory(raw_msg), WEIXIN_MSG_RAW => env[POST_BODY]
                    @app.call(env)
                rescue Exception => e
                    return [500, { 'Content-typ' => 'text/html' }, ["Message parsing error: #{e.to_s}"]]
                end
            else
                @app.call(env)
            end

        end

        def invalid_request!
            [401, { 'Content-type' => 'text/html', 'Content-Length' => '0'}, []]
        end

        def request_is_valid?
            begin
                param_array = [@app_token, @req.params['timestamp'], @req.params['nonce']]
                sign = Digest::SHA1.hexdigest( param_array.sort.join )
                sign == @req.params['signature'] ? true : false
            rescue
                false
            end
        end
    end

end

