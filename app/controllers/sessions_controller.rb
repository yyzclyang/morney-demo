class SessionsController < ApplicationController
  def create
    session = Session.new create_params
    session.validate
    render_resource session
  end

  def destroy

  end

  def create_params
    params.permit(:email, :password)
  end

  def render_resource(resource)
    if resource.errors.empty?
      render json: {msg: "success", resource: {email: resource.email}}, status: 200
    else
      render json: {errors: resource.errors}, status: 400
    end
  end
end
