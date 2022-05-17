class UserController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
end
