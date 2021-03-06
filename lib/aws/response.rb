# Copyright 2011 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'aws/async_handle'

module AWS

  # @private
  class Response

    include AsyncHandle

    # @return [AWS::Error] Returns nil unless the request failed.
    #   Normally this will be nil unless you are using the Asynchronous 
    #   interface.
    attr_accessor :error
    
    # @return [Hash] The hash of options passed to the low level request 
    #   method that generated this response.
    attr_accessor :request_options

    # @return [Symbol] The low-level request method that generated
    #   this response
    attr_accessor :request_type
    
    # @return [Http::Request] the HTTP request object 
    attr_accessor :http_request

    # @return [Http::Response] the HTTP response object 
    attr_accessor :http_response

    # @return [Boolean] true if the response is cached
    attr_accessor :cached

    # @param [Http::Request] http_request
    # @param [Http::Response] http_request
    def initialize http_request = nil, http_response = nil
      @http_request = http_request
      @http_response = http_response
    end

    # @return [Boolean] Teturns true unless there is a response error.
    def successful?
      error.nil?
    end

    # @return [Boolean] Returns true if the http request was throttled
    #   by AWS.
    def throttled?
      !successful? and
        parsed_body = XmlGrammar.parse(http_response.body) and
        parsed_body.respond_to?(:code) and
        parsed_body.code == "Throttling"
    end

    # @return [Boolean] Returns true if the http request timed out.
    def timeout?
      http_response.timeout?
    end

    # @private
    def inspect
      "<#{self.class}>"
    end

    def cache_key
      [http_request.access_key_id,
       http_request.host,
       request_type,
       serialized_options].join(":")
    end

    def serialized_options
      serialize_options_hash(request_options)
    end

    private
    def serialize_options_hash(hash)
      "(" + hash.keys.sort_by(&:to_s).map do |key|
        "#{key}=#{serialize_options_value(hash[key])}"
      end.join(" ") + ")"
    end

    private
    def serialize_options_value(value)
      case value
      when Hash
        serialize_options_hash(value)
      when Array
        serialize_options_array(value)
      else
        value.inspect
      end
    end

    private
    def serialize_options_array(ary)
      "[" + ary.map { |v| serialize_options_value(v) }.join(" ") +
        "]"
    end

  end
end
