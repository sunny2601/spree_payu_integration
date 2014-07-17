module Spree
	class PayuController < Spree::BaseController
		def notify
			@response = OpenPayU::Order.consume_notification(request)

			case @response.order_status
			when 'NEW'
			when 'PENDING'
			when 'CANCELLED'
			when 'REJECTED'
			when 'COMPLETED'
			when 'WAITING_FOR_CONFIRMATION'
			end

			render json: OpenPayU::Order.build_notify_response(@response.req_id)
		end

		def continue
		end
	end
end