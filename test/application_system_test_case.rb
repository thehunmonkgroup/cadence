# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: ENV['TEST_GUI'] == '1' ? :chrome : :headless_chrome,
                       screen_size: [1280, 900] do |options|
    options.add_preference('credentials_enable_service', false)
    options.add_preference('profile.password_manager_enabled', false)
    options.add_preference('autofill.profile_enabled', false)
    options.add_preference('autofill.credit_card_enabled', false)
  end
end
