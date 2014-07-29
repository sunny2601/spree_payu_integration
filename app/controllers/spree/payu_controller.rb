module Spree
  class PayuController < Spree::BaseController
    protect_from_forgery except: [:notify, :continue]

    def notify
      @response = OpenPayU::Order.retrieve(params[:order][:orderId])
      @order_info = response.parsed_data['orders']['orders'].first
      @payment = Spree::Order.find(order_info['extOrderId']).payments.last

      if @payment.completed?
        render json: OpenPayU::Order.build_notify_response(response.req_id)
      else
        complete_payment
      end
    end

    def continue
    end

  private

    def complete_payment
      case @order_info['status']
      when 'CANCELED', 'REJECTED'
        @payment.failure!
      when 'COMPLETED'
        @payment.complete!
      end

      render json: OpenPayU::Order.build_notify_response(@response.req_id)
    end
  end
end