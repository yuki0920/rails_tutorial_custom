# frozen_string_literal: true

module TestHelper
  def is_logged_in?
    !page.get_rack_session_key('user_id').nil?
  end
end
