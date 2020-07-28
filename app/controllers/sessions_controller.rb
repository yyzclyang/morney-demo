class SessionsController < ApplicationController
  def create
    s = Session.new create_params
    s.validate
    render_resource s
    session[:current_user_id] = s.user.id if s.user.present?
  end

  def destroy
    session[:current_user_id] = nil
    render json: {msg: "success"}, status: 200
  end

  def create_params
    params.permit(:email, :password)
  end

  def render_resource(resource)
    if resource.errors.empty?
      render json: {msg: "success", resource: {email: resource.email}}, status: 200
    else
      render json: {errors: resource.errors}, status: 422
    end
  end
end
