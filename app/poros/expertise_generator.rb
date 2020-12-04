class ExpertiseGenerator
  cattr_reader :personal_website_missing_headers_error do ApiError.build(
    name: 'PersonalWebsiteMissingHeadersError',
    base: 'ScrapingError',
    message: 'Personal website is bereft of headers',
    code: '0101',
    http_status_code: 422
  )
  end
  cattr_reader :invalid_personal_website_error do ApiError.build(
    name: 'InvalidPersonalWebsiteError',
    base: 'ScrapingError',
    message: 'Personal website is bereft of headers',
    code: '0102',
    http_status_code: 422
  )
  end

  EXPERTISE_CSS_CRITERIA = 'h1, h2, h3'.freeze

  def self.generate(personal_website)
    page               = RestClient.get(personal_website)
    parsed_page        = Nokogiri::HTML.parse(page)
    expertise_headers = parsed_page.css(EXPERTISE_CSS_CRITERIA).map(&:text)
    raise personal_website_missing_headers_error if expertise_headers.empty?
    expertise_headers
  rescue RestClient::Exception
    raise @@invalid_personal_website_error
  end
end
