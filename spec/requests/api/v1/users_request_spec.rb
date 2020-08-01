require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  before { create_list(:user, 20) }
  let(:user) { User.first }

  let(:params) { {name: 'Foo bar', email: 'foo@bar.com', password: 'foobar', password_confirmation: 'foobar'} }
  let(:invalid_params) { {name: 'Foo bar', email: 'foo@bar.com', password: 'foobar', password_confirmation: 'barbaz'} }

  let(:headers) { {
    HTTP_ACCEPT: 'applicaton/json',
    HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials('user', 'password')
  } }

  describe 'GET /api/v1/users' do
    before { get api_v1_users_path, headers: headers }

    subject { JSON.parse(response.body)[0] }

    it {
      expect(response).to have_http_status(:success)
      expect(subject['id']).to eq user.id
      expect(subject['name']).to eq user.name
    }
  end

  describe 'GET /api/v1/user/:id' do
    context 'valid user_id' do
      before { get api_v1_user_path(user), headers: headers }

      subject { JSON.parse(response.body) }

      it {
        expect(response).to have_http_status(:success)
        expect(subject['id']).to eq user.id
        expect(subject['name']).to eq user.name
      }
    end

    context 'invalid user_id' do
      before { get "/api/v1/users/0", headers: headers }

      subject { JSON.parse(response.body) }

      it {
        expect(response).to have_http_status(:not_found)
      }
    end
  end

  describe 'POST /api/v1/users' do
    context 'valid params' do
      before { post api_v1_users_path, params: params, headers: headers }

      subject { JSON.parse(response.body) }

      it {
        expect(response).to have_http_status(:success)
        expect(subject['name']).to eq('Foo bar')
        expect(subject['email']).to eq('foo@bar.com')
      }

      subject { User.last }

      it {
        expect(subject.name).to eq('Foo bar')
        expect(subject.email).to eq('foo@bar.com')
      }
    end

    context 'invalid params' do
      before { post api_v1_users_path, params: invalid_params, headers: headers }

      subject { JSON.parse(response.body) }

      it {
        expect(response).to have_http_status(:unprocessable_entity)
      }
    end
  end

  describe 'PATCH /api/v1/users/:id' do
    context 'valid params' do
      before { post api_v1_users_path, params: params, headers: headers }

      subject { JSON.parse(response.body) }

      it {
        expect(response).to have_http_status(:success)
        expect(subject['name']).to eq('Foo bar')
        expect(subject['email']).to eq('foo@bar.com')
      }

      subject { User.last }

      it {
        expect(subject.name).to eq('Foo bar')
        expect(subject.email).to eq('foo@bar.com')
      }
    end

    context 'invalid params' do
      before { post api_v1_users_path, params: invalid_params, headers: headers }

      subject { JSON.parse(response.body) }

      it {
        expect(response).to have_http_status(:unprocessable_entity)
      }
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    let(:delete_user) { user }

    before { delete api_v1_user_path(delete_user), headers: headers }
    it {
      expect(delete_user).to_not eq User.first
      expect(response).to have_http_status(:no_content)
    }
  end
end
