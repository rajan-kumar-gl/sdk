module Proto
  module Upstream
    def send_in_bulk ( msg = "", users = [], opts = {})
      raise NoMethodError "Not implemented"
    end
    def schedule_sms ( msg = "", users = [], opts = {})
      raise NoMethodError "Not implemented"
    end
  end
end