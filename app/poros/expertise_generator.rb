class ExpertiseGenerator
  cattr_reader :personal_website_missing_headers_error do ApiError.build(
    name: 'PersonalWebsiteMissingHeadersError',
    base: 'ScrapingError',
    message: 'Personal website is bereft of headers',
    code: '0101',
    http_status_code: 422
  )
  end

  def self.generate(*args)
  end
end

