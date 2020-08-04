class RecordsController < ApplicationController
  before_action :must_sign_in

  def create
    record = Record.create(create_params)
    render_resource record
  end

  def destroy
    record = Record.find params[:id]
    head record.destroy ? 200 : 400
  end

  def index
    render_resources Record.page(params[:page])
  end

  def show
    render_resource Record.find_by_id params[:id]
  end

  private

  def create_params
    params.permit(:amount, :category, :notes)
  end

  def render_resources(resources)
    return head 404 if resources.nil?
    render json: {msg: "success", resources: resources}
  end

  def render_resource(resource)
    return head 404 if resource.nil?
    if resource.errors.empty?
      render json: {msg: "success", resource: resource}, status: 200
    else
      render json: {errors: resource.errors}, status: 422
    end
  end
end
