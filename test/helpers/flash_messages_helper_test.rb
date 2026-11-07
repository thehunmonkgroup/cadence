# frozen_string_literal: true

require 'test_helper'

class FlashMessagesHelperTest < ActionView::TestCase
  test 'flash messages render client supplied content as text' do
    flash[:notice] = '<script>alert("client text")</script>'
    fragment = Nokogiri::HTML.fragment(flash_messages)

    assert_empty fragment.css('script')
    assert_equal flash[:notice], fragment.at_css('[role="status"]').text
  end
end
