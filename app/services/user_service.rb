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

  attr_reader(
    :expertise_generator,
    :name,
    :personal_website,
    :url_shortener
  )
  HTTP_PROTOCOL  = 'http://'.freeze
  HTTPS_PROTOCOL = 'https://'.freeze

  def initialize(
    expertise_generator: Rails.application.config.expertise_generator.constantize,
    name:,
    personal_website:,
    url_shortener: Rails.application.config.url_shortener.constantize
  )
    @name                = name
    @personal_website    = format_personal_website(personal_website)
    @expertise_generator = expertise_generator
    @url_shortener       = url_shortener
  end

  def self.create!(name:, personal_website:)
    raise name_not_provided_error             unless name
    raise personal_website_not_provided_error unless personal_website
    new(name: name, personal_website: personal_website).create!
  end

  def create!
    User.create!(
      name: name,
      personal_website: personal_website,
      expertise: expertise(personal_website),
      shortened_website: shortened_website(personal_website)
    )
  end

  def format_personal_website(personal_website)
    if personal_website.starts_with?(HTTP_PROTOCOL) ||
        personal_website.starts_with?(HTTPS_PROTOCOL)
      personal_website
    else
      'http://' + personal_website
    end
  end

  def expertise(personal_website)
    expertise_generator.generate(personal_website)
  end

  def shortened_website(personal_website)
    url_shortener.shorten(personal_website)
  end
end
