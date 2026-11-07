# frozen_string_literal: true

MissionControl::Jobs.base_controller_class = 'Admin::JobsController'
# Every engine action passes through the application's Pundit gate.
MissionControl::Jobs.http_basic_auth_enabled = false
