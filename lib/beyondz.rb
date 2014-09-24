module BeyondZ
  class CustomAuthenticator < CASServer::Authenticators::Base
    def self.setup(options)
      raise CASServer::AuthenticatorError, "Authenticator configuration needs server" unless options[:server]

      @@server = options[:server]
      @@ssl = (!options[:ssl].nil?) ? options[:ssl] : true
      @@port = (!options[:port].nil?) ? options[:port] : (@@ssl ? 443 : 80)
      @@allow_self_signed = (!options[:allow_self_signed].nil?) ? options[:allow_self_signed] : false
    end

    def validate(credentials)
      http = Net::HTTP.new(@@server, @@port)
      if @@ssl
        http.use_ssl = true
        if @@allow_self_signed
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE # self-signed cert would fail
        end
      end

      request = Net::HTTP::Get.new("/users/check_credentials?username=#{URI::encode_www_form_component(credentials[:username])}&password=#{URI::encode_www_form_component(credentials[:password])}")
      response = http.request(request)

      return (response.body == "true")
    end
  end
end
