require 'proto/upstream'
module Upstreams

  class MSG91
    require 'uri'
    require 'net/http'
    require "json"

    include Proto::Upstream

    #Upstream Specific data
    @access_token =''
    @sender_id = ''
    @flow_id = ''

    #Upstream Specific constants
    CONTENT_TYPE = 'application/json'.freeze
    HOST ='https://api.msg91.com/api'.freeze
    RESPONSE_STATUS = {
        error: 'error',
        success:'success'
    }

    def initialize(opts = {})

      raise StandardError.new "MSG91::connect.Unexpected nil opts provided." if opts.nil?
      raise StandardError.new "MSG91::connect.Unexpected nil sender id provided." if opts[:sender_id].nil?
      raise StandardError.new "MSG91::connect.Unexpected nil access token provided." if opts[:access_token].nil?
      raise StandardError.new "MSG91::connect.Unexpected nil flow id provided." if opts[:flow_id].nil?
      @access_token, @sender_id, @flow_id = opts[:access_token], opts[:sender_id], opts[:flow_id]

    end

    def send_in_bulk ( msg = "", users = [], opts = {})

      #checking up the base conditions
      return false, "MSG91::send_in_bulk.Unexpected nil opts found in msg91" if opts.nil?
      return false, "MSG91::send_in_bulk.Unexpected nil users info found in msg91" if users.nil? || users.length.zero?

      #Setting up the request payload
      payload = {}
      payload[:flow_id] = @flow_id unless @flow_id.nil?
      payload[:sender] = @sender_id unless @sender_id.nil?
      payload[:recipients] = users unless users.nil?

      # calling the upstream to post the request
      response = post_to_upstream("#{HOST}/v5/flow", payload)

      #checking the error stats
      return false, "MSG91::send_in_bulk.Unable to post request to upstream" if response.nil? || response[:type].nil?
      return false,response[:message] if response[:type].eql?(RESPONSE_STATUS.error)

      [true,nil]
    end

    private

    def post_to_upstream (url = "", body = {})
      #Setting up the HTTP Client
      url = URI.parse(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      #Setting up the request
      request = Net::HTTP::Post.new(url.request_uri)
      request['content-type'] = CONTENT_TYPE
      request['authkey'] =  @access_token
      request.body = body.to_json unless body.nil?

      # sending request to upstream
      response = http.request(request)

      #processing the response string
      JSON.parse(response.body)
    end

  end
end

