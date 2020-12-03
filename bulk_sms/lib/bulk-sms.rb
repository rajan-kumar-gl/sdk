# frozen_string_literal: true
#
require 'clients/msg_91'
require 'constants'

module BulkSMS

    class Adapter

      def self.connect(client_name = "", opts = {})
        case client_name
        when BulkSMS::Clients::MSG91
          Upstreams::MSG91.new opts
        else
          raise StandardError.new "No Client found for #{client_name}"
        end
      end
  end
end