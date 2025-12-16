class ApplicationController < ActionController::Base
  include InertiaRails::Controller
  inertia_share flash: -> { flash.to_hash }
  layout 'inertia'
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
