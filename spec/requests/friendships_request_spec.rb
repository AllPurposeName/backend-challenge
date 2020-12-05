require 'rails_helper'

RSpec.describe "Friendships", type: :request do

  describe 'POST' do
    let(:user_name)   { 'David' }
    let(:friend_name) { 'Bowie' }
    let(:user)        { User.create!(name: user_name) }
    let(:friend)      { User.create!(name: friend_name) }
    let(:required_params)  do
      {
        user_id: user.id,
        friend_id: friend.id,
      }
    end

    it 'creates a friendship' do
      expect do
        post '/friendships', params: required_params
      end.to change { Friendship.count }.by(2)

      resp = JSON.parse(response.body)

      expect(resp['user']['name']).to eq(user_name)
      expect(resp['friend']['name']).to eq(friend_name)
    end

    describe 'error states' do

      context 'when a user id is invalid' do
        subject(:make_request) do
          post '/friendships', params: required_params.merge(user_id: (User.maximum(:id) + 1))
        end

        let(:expected_message)     { 'One or more of ids supplied were invalid' }
        let(:expected_error_code)  { '0201' }
        let(:expected_status_code) { 422 }
        it_behaves_like('errors are handled')
      end

      context 'when a friend id is invalid' do
        subject(:make_request) do
          post '/friendships', params: required_params.merge(friend_id: 0)
        end

        let(:expected_message)     { 'One or more of ids supplied were invalid' }
        let(:expected_error_code)  { '0201' }
        let(:expected_status_code) { 422 }
        it_behaves_like('errors are handled')
      end

      context "when they're already friends!" do
        before do
          Friendship.create!(user: user, friend: friend)
        end
        subject(:make_request) do
          post '/friendships', params: required_params
        end

        let(:expected_message)     { 'These users are already friends' }
        let(:expected_error_code)  { '0202' }
        let(:expected_status_code) { 409 }
        it_behaves_like('errors are handled')
      end
    end
  end
end
