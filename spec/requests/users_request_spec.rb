require 'rails_helper'

RSpec.describe 'Users', type: :request do

  describe 'POST' do
    let(:name)             { 'Tarn Adams' }
    let(:personal_website) { 'https://www.google.com' }
    let(:required_params)  do
      {
        name: name,
        personal_website: personal_website,
      }
    end

    it 'creates a user' do
      expect do
        post '/users', params: required_params
      end.to change { User.count }.by(1)

      resp = JSON.parse(response.body)

      expect(resp['name']).to eq(name)
      expect(resp['personal_website']).to eq(personal_website)
    end

    it "coerces a url without it's protocol" do
      post '/users', params: required_params.merge(personal_website: personal_website.sub('http://', ''))

      resp = JSON.parse(response.body)

      expect(resp['personal_website']).to eq(personal_website)
    end

    describe 'error states' do

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

      context 'when no valid headers are found' do
        class MockFailingExpertiseGenerator
          PersonalWebsiteMissingHeadersError = Class.new(ApiError::BasicError) do
            define_method(:external_message) { 'Personal website is bereft of headers' }
            define_method(:error_code)       { '0101' }
            define_method(:http_status_code) { 422 }
          end
          def self.generate(*args)
            raise PersonalWebsiteMissingHeadersError
          end
        end

        before do
          Rails.application.config.stub(:expertise_generator).and_return('MockFailingExpertiseGenerator')
        end
        subject(:make_request) do
          post '/users', params: required_params
        end

        let(:expected_message)     { 'Personal website is bereft of headers' }
        let(:expected_error_code)  { '0101' }
        let(:expected_status_code) { 422 }
        it_behaves_like('errors are handled')
      end

      context "when url shortener's client fails" do
        class MockFailingUrlShortener
          ClientFailureError = Class.new(ApiError::BasicError) do
            define_method(:external_message) { 'The external url shortener could not be reached at this moment' }
            define_method(:error_code)       { '0301' }
            define_method(:http_status_code) { 424 }
          end
          def self.shorten(*args)
            raise ClientFailureError
          end
        end

        before do
          Rails.application.config.stub(:url_shortener).and_return('MockFailingUrlShortener')
        end
        subject(:make_request) do
          post '/users', params: required_params
        end

        let(:expected_message)     { 'The external url shortener could not be reached at this moment' }
        let(:expected_error_code)  { '0301' }
        let(:expected_status_code) { 424 }
        it_behaves_like('errors are handled')
      end
    end
  end
end
