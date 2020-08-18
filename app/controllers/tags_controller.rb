class TagsController < ApplicationController
  before_action :must_sign_in

  def create
    tag = Tag.create(create_params.merge user: current_user)
    render_resource tag
  end

  def destroy
    tag = Tag.find_by_id params[:id]
    head tag&.destroy ? 200 : 400
  end

  def index
    render_resources Tag.page(params[:page])
  end

  def show
    render_resource Tag.find_by_id params[:id]
  end

  def update
    tag = Tag.find_by_id params[:id]
    tag&.update create_params
    render_resource tag
  end


  private

  def create_params
    params.permit(:name)
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
