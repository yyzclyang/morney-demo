class TaggingsController < ApplicationController
  before_action :must_sign_in

  def create
    tagging = Tagging.create(create_params.merge user: current_user)
    render_resource tagging
  end

  def destroy
    tagging = Tagging.find_by_id params[:id]
    head tagging&.destroy ? 200 : 400
  end

  def index
    render_resources Tagging.page(params[:page])
  end

  def show
    render_resource Tagging.find_by_id params[:id]
  end

  private

  def create_params
    params.permit(:record_id, :tag_id)
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
