# frozen_string_literal: true

SolidQueue.on_worker_start do
  # Warm lazy routes before multiple development jobs try to generate URLs.
  Rails.application.reload_routes_unless_loaded
end
