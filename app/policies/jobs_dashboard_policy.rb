# frozen_string_literal: true

class JobsDashboardPolicy < ApplicationPolicy
  def show?
    user.present? && %w[practitioner admin].include?(user.role)
  end
end
