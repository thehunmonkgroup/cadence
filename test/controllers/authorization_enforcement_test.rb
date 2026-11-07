# frozen_string_literal: true

require 'test_helper'

# Controller tests exercise verification failures directly without test-only application endpoints.
class AuthorizationEnforcementTest < ActionController::TestCase # rubocop:disable Rails/ActionControllerTestCase
  class ProbeController < ApplicationController
    def show
      head :ok
    end

    def index
      authorize :jobs_dashboard, :show?
      head :ok
    end
  end

  tests ProbeController

  setup do
    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw do
      get 'probe', to: 'authorization_enforcement_test/probe#show'
      get 'probes', to: 'authorization_enforcement_test/probe#index'
    end
  end

  test 'a controller action must explicitly authorize access' do
    assert_raises(Pundit::AuthorizationNotPerformedError) { get :show }
  end

  test 'an authorized collection must also declare its record scope' do
    actor = Data.define(:role).new(role: 'admin')
    @controller.define_singleton_method(:current_user) { actor }

    assert_raises(Pundit::PolicyScopingNotPerformedError) { get :index }
  end
end
