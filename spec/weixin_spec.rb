require 'rspec'
require 'rack/mock'
require 'digest/sha1'
require 'weixin'

describe "Weixin" do

    #include Rack::Test:Methods

    before(:all) do
        @app = lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['hello']] }
        @app_token = 'mytoken'
    end

    def middleware()
        Weixin.new @app, @app_token
    end

    def mock_env(echostr, token = @app_token)
        timestamp = Time.now.to_i.to_s
        nonce = '123456'
        param_array = [token, timestamp, nonce]
        sign = Digest::SHA1.hexdigest( param_array.sort.join )
        path = "/?echostr=#{echostr}&timestamp=#{timestamp}&nonce=#{nonce}&signature=#{sign}"
        Rack::MockRequest.env_for(path)
    end

    it 'is valid weixin request' do
        app = middleware
        echostr = '123'
        status, headers, body = app.call mock_env(echostr)
        status.should eq(200)
        body.should eq([echostr])
    end

    it 'is invalid weixin request' do
        app = middleware
        status, headers, body = app.call mock_env('123', 'wrong_token')
        status.should eq(401)
        body.should eq([])
    end

end
