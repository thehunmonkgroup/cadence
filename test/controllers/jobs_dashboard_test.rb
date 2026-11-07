# frozen_string_literal: true

require 'test_helper'

# Supply the verified actor at the controller seam while application authentication remains deferred.
class JobsDashboardTest < ActionController::TestCase # rubocop:disable Rails/ActionControllerTestCase
  tests MissionControl::Jobs::QueuesController

  setup do
    @routes = MissionControl::Jobs::Engine.routes
  end

  test 'an authenticated practitioner can load the durable queue dashboard' do
    actor = Data.define(:role).new(role: 'practitioner')
    @controller.define_singleton_method(:current_user) { actor }

    get :index

    assert_response :success
  end

  test 'an authenticated client cannot load the dashboard' do
    actor = Data.define(:role).new(role: 'client')
    @controller.define_singleton_method(:current_user) { actor }

    get :index

    assert_response :forbidden
  end
end
