class UsersController < ApplicationController
  def create
    user = User.create(create_params)
    render_resource user
    UserMailer.welcome_email(user).deliver_later
  end

  def create_params
    params.permit(:email, :password, :password_confirmation)
  end

  def render_resource(resource)
    if resource.errors.empty?
      render json: {msg: "success", resource: {email: resource.email}}, status: 200
    else
      render json: {errors: resource.errors}, status: 400
    end
  end
end
