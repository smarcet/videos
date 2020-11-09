module Auth
  class CustomAuth < Devise::Strategies::Authenticatable

    # it must have a `valid?` method to check if it is appropriate to use
    # for a given request
    def valid?
      true
    end

    FAIL_MESSAGE = 'Unknown user account.'

    # it must have an authenticate! method to perform the validation
    # a successful request calls `success!` with a user object to stop
    # other strategies and set up the session state for the user logged in
    # with that user object.
    def authenticate!
      begin
        api = ::Services::ZypeApi.new
        response = api.auth email, password
        if response.key?('access_token')
          access_token = response['access_token']
          refresh_token = response.key?('refresh_token') ? response['refresh_token'] : nil
          user = User.find_or_create_by(email: email.downcase)
          user.access_token = access_token
          user.refresh_token = refresh_token
          res = user.save
          unless res
            fail! FAIL_MESSAGE
          end
          success! user and return
        end
      rescue Exception => e
        fail! FAIL_MESSAGE
      end
      fail! FAIL_MESSAGE
    end

    private

    def email
      (params[:user] || {})[:email]
    end

    def password
      (params[:user] || {})[:password]
    end

  end
end
