require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe 'error states' do
    let(:required_params) { { name: 'Tarn Adams', personal_website: 'www.google.com' } }

    context 'when a user name is not supplied' do
      subject(:make_request) do
        post '/users', params: required_params.except(:name)
      end

      let(:expected_message)     { 'No name provided' }
      let(:expected_error_code)  { '0001' }
      let(:expected_status_code) { 422 }
      it_behaves_like('errors are handled')
    end

    context 'when a personal_website is not unique' do
      subject(:make_request) do
        post '/users', params: required_params.except(:personal_website)
      end

      let(:expected_message)     { 'No personal_website provided' }
      let(:expected_error_code)  { '0002' }
      let(:expected_status_code) { 422 }
      it_behaves_like('errors are handled')
    end
  end
end
