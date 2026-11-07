# frozen_string_literal: true

require 'test_helper'

class JobsDashboardAccessTest < ActionDispatch::IntegrationTest
  test 'unauthenticated requests cannot inspect jobs or grant themselves access' do
    get '/admin/jobs', params: { role: 'admin', user_id: 1 }

    assert_response :forbidden
  end

  test 'unauthenticated requests cannot retry jobs' do
    post '/admin/jobs/applications/Cadence/jobs/1/retry', params: { server_id: 'solid_queue' }

    assert_response :forbidden
  end
end
