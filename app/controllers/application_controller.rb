# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  after_action :verify_authorized
  after_action :verify_policy_scoped, if: -> { action_name == 'index' }
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
  helper_method :current_user

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  # Authentication will supply the verified actor here once the sign-in flow is selected.
  # Never derive this identity or its role from request parameters.
  def current_user
    nil
  end

  def render_forbidden
    head :forbidden
  end
end
