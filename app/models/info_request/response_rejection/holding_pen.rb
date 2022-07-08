class InfoRequest
  module ResponseRejection
    class HoldingPen < Base
      attr_reader :holding_pen

      def initialize(info_request, email, raw_email_data)
        super
        @holding_pen = InfoRequest.holding_pen_request
      end

      def reject(reason = nil)
        if info_request == holding_pen
          false
        else
          holding_pen.receive(email,
                              raw_email_data,
                              { :rejected_reason => reason })
        end
      end
    end
  end
end
