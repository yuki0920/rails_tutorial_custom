# frozen_string_literal: true

module TestHelper
  def is_logged_in?
    !page.get_rack_session_key('user_id').nil?
  end

  # def log_in_as(user)
  #   session[:user_id] = user.id
  # end

  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session:
      { email: user.email, password: password, remember_me: remember_me, }
    }
  end
end
