# frozen_string_literal: true

module FlashMessagesHelper
  FLASH_STYLES = {
    'notice' => 'alert-success',
    'success' => 'alert-success',
    'alert' => 'alert-error',
    'error' => 'alert-error',
    'warning' => 'alert-warning',
  }.freeze

  def flash_messages
    safe_join(flash.filter_map do |type, message|
      next unless message.is_a?(String)

      urgent = %w[alert error].include?(type.to_s)
      tag.div(class: ['alert', FLASH_STYLES.fetch(type.to_s, 'alert-info')], role: urgent ? 'alert' : 'status') do
        # Messages can contain client-provided text. Render them as text, even if marked HTML-safe upstream.
        ERB::Util.html_escape(String.new(message))
      end
    end)
  end
end
