class RecordsController < ApplicationController
  def create
    must_sign_in
    record = Record.create(create_params)
    render_resource record
  end

  def create_params
    params.permit(:amount, :category, :notes)
  end

  def render_resource(resource)
    return head 404 if resource.nil?
    if resource.errors.empty?
      render json: {msg: "success"}, status: 200
    else
      render json: {errors: resource.errors}, status: 422
    end
  end
end
