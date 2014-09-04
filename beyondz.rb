module BeyondZ
  class CustomAuthenticator < CASServer::Authenticators::Base
    def self.setup(options)
    end

    def validate(credentials)
      return true
    end
  end
end
