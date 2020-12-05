require 'rails_helper'

RSpec.describe 'Users', type: :service do
  describe '#create!/0' do
    let(:mock_expertise_generator) do
      class MockExpertiseGenerator
        def generate(*args)
          raise ApiError::PersonalWebsiteMissingHeadersError
        end
      end
      MockExpertiseGenerator.new
    end
    let(:subject) do
      UserService.new(name: 'Adam', personal_website: 'www.bay12games.com', expertise_generator: mock_expertise_generator)
    end
    it 'raises an error if no valid headers are found' do
      expect do
        subject.create!
      end.to raise_error(ApiError::PersonalWebsiteMissingHeadersError)
    end
  end
end
