require 'proto/upstream'
require 'erb'

# Ref : https://developers.kaleyra.io/docs/send-bulk-sms
module Upstreams
  include ERB::Util

  class Kaleyra
    require 'uri'
    require 'net/http'
    require "json"

    include Proto::Upstream

    #Upstream Specific data
    @api_key = ''
    @sender_id = ''
    @sid = ""

    #Upstream Specific constants
    CONTENT_TYPE = 'application/json'.freeze
    HOST ='https://api.kaleyra.io'.freeze


    def initialize(opts = {})

      raise StandardError.new "Kaleyra::connect.Unexpected nil opts provided." if opts.nil?
      raise StandardError.new "Kaleyra::connect.Unexpected nil sender id provided." if opts[:sender_id].nil?
      raise StandardError.new "Kaleyra::connect.Unexpected nil API key provided." if opts[:api_key].nil?

      @api_key, @sender_id = opts[:api_key], opts[:sender_id]

    end

    def schedule_sms ( msg = "", users = [], opts = {})

      #checking up the base conditions
      return false, ["Kaleyra::schedule_sms.Unexpected nil opts found"] if msg.nil? || msg.empty?
      return false, ["Kaleyra::schedule_sms.Unexpected nil users info found"] if users.nil? || users.empty?
      return false, ["Kaleyra::schedule_sms.Unexpected nil time found"] if opts[:time].nil?

      # processing all user mobile no
      all_phone_numbers = get_all_phone_no users
      return true,["Kaleyra::schedule_sms.Unexpected zero contact provided"] if all_phone_numbers.empty?

      #common payload for each batch
      payload = {
          'api_key': @access_token,
          'method': 'sms',
          'message': msg,
          'sender': @sender_id,
          'time': opts[:time]
      }

      errors = []

      # sending request in batch of 50
      all_phone_numbers.each_slice(50) do | phone_numbers |

        to_str = phone_numbers.join(",")
        payload[:to] = to_str

        #building query string from hash of params
        query_string = build_query_str payload

        # calling the upstream to post the request
        response = post_to_upstream("/v1/#{@sid}/messages?#{query_string}")

        errors << ["error while sending sms to #{to_str} error : #{response.to_s}"] unless response[:status].eql?("OK")

        # sleep for 6ms for preventing too many request error 100 request per second
        sleep(0.0006)
      end
      return false, errors unless errors.empty?

      [true,nil]
    end

    private

    def post_to_upstream (url = "", body = {})
      #Setting up the HTTP Client
      url = URI.parse(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      #Setting up the request
      request = Net::HTTP::Get.new(url.request_uri)

      # sending request to upstream
      response = http.request(request)

      #processing the response string
      JSON.parse(response.body)
    end

    # building Query string fro hash
    def build_query_str (params = {})
      query = []
      params.each do | key, value|
        query << "#{key}=#{url_encode(value)}"
      end
      query.compact!
      query.join('&')
    end

    # this method fetch user's mobile no in array
    def get_all_phone_no (users = {})
      all_phone_numbers = []
      users.each do | u | all_phone_numbers << u[:mobile_no] end
      all_phone_numbers.uniq!
      all_phone_numbers.compact!
    end

  end
end

