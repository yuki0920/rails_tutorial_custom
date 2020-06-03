# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:user) { create :user }

    subject(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Account Activation')
      expect(mail.to).to eq(['sample@example.com'])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      user.activation_token = User.new_token
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(user.activation_token)
      # expect(mail.body.encoded).to match(CGI.escape(user.email))
      expect(mail.body.encoded).to match(user.email)
    end
  end
end
