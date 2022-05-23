module DeviseTokenAuthHelpers
  HEADERS = { "ACCEPT" => "application/json" }
  SIGN_IN_PATH = "/api/v1/auth/sign_in"

  def sign_in(user)
    options = { 
                :params => { email: user.email, password: user.password}, 
                :headers => HEADERS
              }

    send("post", SIGN_IN_PATH, options)
    %w[uid client access-token].each_with_object({}) { |attr, h| h[attr] = response.headers[attr] }
  rescue
    false
  end
end

RSpec.configure do |config|
  config.include DeviseTokenAuthHelpers
end