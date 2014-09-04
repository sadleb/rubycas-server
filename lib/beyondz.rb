module BeyondZ
  class CustomAuthenticator < CASServer::Authenticators::Base
    def self.setup(options)
    end

    def validate(credentials)
      http = Net::HTTP.new("platform.beyondz.org.arsdnet.net", 80)
      #http.use_ssl = true
      #http.verify_mode = OpenSSL::SSL::VERIFY_NONE # self-signed cert would fail

      request = Net::HTTP::Get.new("/users/check_credentials?username=#{URI::encode_www_form_component(credentials[:username])}&password=#{URI::encode_www_form_component(credentials[:password])}")
      response = http.request(request)

      return (response.body == "true")
    end
  end
end
