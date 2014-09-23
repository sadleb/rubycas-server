module BeyondZ
  class CustomAuthenticator < CASServer::Authenticators::Base
    def self.setup(options)
      raise CASServer::AuthenticatorError, "Authenticator configuration needs server" unless options[:server]

      @server = options[:server]
      @port = options[:port] ? options[:port].to_i : 80
      @ssl = options[:ssl] ? options[:ssl].to_b : false
    end

    def validate(credentials)
      http = Net::HTTP.new(@server, @port)
      if @ssl
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE # self-signed cert would fail
      end

      request = Net::HTTP::Get.new("/users/check_credentials?username=#{URI::encode_www_form_component(credentials[:username])}&password=#{URI::encode_www_form_component(credentials[:password])}")
      response = http.request(request)

      return (response.body == "true")
    end
  end
end
