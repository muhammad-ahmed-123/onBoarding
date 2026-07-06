class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # JSON requests have no CSRF-vulnerable cookie session to protect (no
  # authentication system exists yet) and can't carry the HTML meta-tag
  # token, so exempt them specifically rather than disabling protection
  # app-wide. HTML form submissions remain fully protected.
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  private

  def render_not_found(exception)
    respond_to do |format|
      format.html { render file: Rails.public_path.join("404.html"), status: :not_found, layout: false }
      format.json { render json: { error: exception.message }, status: :not_found }
      format.any { head :not_found }
    end
  end
end
