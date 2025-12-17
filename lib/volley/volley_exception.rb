# frozen_string_literal: true

module Volley
  # Exception thrown when a Volley API request fails.
  class VolleyException < StandardError
    attr_reader :status_code

    # Initializes a new instance of the VolleyException class.
    #
    # @param message [String] Error message
    # @param status_code [Integer] HTTP status code
    def initialize(message = '', status_code = 0)
      super(message)
      @status_code = status_code
    end

    # Checks if the exception represents an unauthorized error (401).
    #
    # @return [Boolean]
    def unauthorized?
      @status_code == 401
    end

    # Checks if the exception represents a forbidden error (403).
    #
    # @return [Boolean]
    def forbidden?
      @status_code == 403
    end

    # Checks if the exception represents a not found error (404).
    #
    # @return [Boolean]
    def not_found?
      @status_code == 404
    end

    # Checks if the exception represents a rate limit error (429).
    #
    # @return [Boolean]
    def rate_limited?
      @status_code == 429
    end

    # Checks if the exception represents a server error (5xx).
    #
    # @return [Boolean]
    def server_error?
      @status_code >= 500 && @status_code < 600
    end
  end
end

