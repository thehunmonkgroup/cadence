# frozen_string_literal: true

require 'test_helper'

class ApplicationJobTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  self.use_transactional_tests = false

  class CommitProbeJob < ApplicationJob
    def perform; end
  end

  test 'jobs become available only after the application transaction commits' do
    assert_enqueued_jobs 1, only: CommitProbeJob do
      ApplicationRecord.transaction do
        CommitProbeJob.perform_later

        assert_no_enqueued_jobs only: CommitProbeJob
      end
    end
  end

  test 'a rolled back application transaction does not enqueue its jobs' do
    assert_no_enqueued_jobs only: CommitProbeJob do
      ApplicationRecord.transaction do
        CommitProbeJob.perform_later
        raise ActiveRecord::Rollback
      end
    end
  end
end
