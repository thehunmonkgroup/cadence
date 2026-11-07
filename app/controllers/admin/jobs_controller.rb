# frozen_string_literal: true

module Admin
  class JobsController < ApplicationController
    before_action :authorize_jobs_dashboard

    private

    def authorize_jobs_dashboard
      authorize :jobs_dashboard, :show?
      # The entire engine is restricted to staff, rather than scoped per client record.
      skip_policy_scope
    end
  end
end
