class Api::V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  alias_method :authenticate_user!, :authenticate_api_v1_user!
end