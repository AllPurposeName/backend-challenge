class UrlShortener
  cattr_reader :client_failure_error do ApiError.build(
    name: 'UrlShortenerClientFailureError',
    base: 'ClientError',
    message: 'The external url shortener could not be reached at this moment',
    code: '0301',
    http_status_code: 424
  )
  end

  attr_reader :client, :personal_website
  def initialize(
    client: Rails.application.config.url_shortener_client.constantize.new,
    personal_website:
  )
    @client           = client
    @personal_website = personal_website
  end

  def self.shorten(personal_website)
    new(personal_website: personal_website).shorten
  end

  def shorten
    shortened_link = client.shorten(personal_website)
    shortened_link.short_url
  rescue Rebrandly::RebrandlyError
    raise @@client_failure_error
  end
end
