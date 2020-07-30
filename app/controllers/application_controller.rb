require 'custom_error'

class ApplicationController < ActionController::API
  rescue_from CustomError::MustSignInError, with: :render_must_sign_in

  # include ActionView::Layouts
  def current_user
    @current_user ||= User.find_by_id session[:current_user_id]
  end

  def must_sign_in
    if current_user.nil?
      raise CustomError::MustSignInError
    end
  end

  def render_must_sign_in
    render status: 401
  end
end
