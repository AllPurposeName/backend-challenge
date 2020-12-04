class UserService
  cattr_reader :name_not_provided_error do ApiError.build(
    name: 'NameNotProvidedError',
    base: 'AuthError',
    message: 'No name provided',
    code: '0001',
    http_status_code: 422
  )
  end

  cattr_reader :personal_website_not_provided_error do ApiError.build(
    name: 'PersonalWebsiteNotProvidedError',
    base: 'AuthError',
    message: 'No personal_website provided',
    code: '0002',
    http_status_code: 422
  )
  end

  attr_reader :name, :personal_website

  def initialize(name:, personal_website:, expertise_generator: ExpertiseGenerator)
    @name             = name
    @personal_website = personal_website
  end

  def self.create!(name:, personal_website:)
    raise name_not_provided_error             unless name
    raise personal_website_not_provided_error unless personal_website
    new(name:, personal_website:).create!

  end

  def create!
    User.create!(
      name: name,
      personal_website: personal_website,
      expertise: expertise(personal_website)
    )
  end

  def expertise(personal_website)
    expertise_generator.generate(personal_website)
  end
end
