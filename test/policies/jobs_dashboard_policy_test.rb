# frozen_string_literal: true

require 'test_helper'

class JobsDashboardPolicyTest < ActiveSupport::TestCase
  Actor = Data.define(:role)

  test 'practitioners and administrators may operate the job dashboard' do
    %w[practitioner admin].each do |role|
      assert_predicate JobsDashboardPolicy.new(Actor.new(role:), :jobs_dashboard), :show?
    end
  end

  test 'anonymous clients and unknown roles cannot operate jobs' do
    [nil, Actor.new(role: 'client'), Actor.new(role: 'unknown')].each do |actor|
      assert_not JobsDashboardPolicy.new(actor, :jobs_dashboard).show?
    end
  end
end
