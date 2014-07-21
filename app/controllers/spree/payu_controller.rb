module Spree
	class PayuController < Spree::BaseController
		protect_from_forgery except: [:notify, :continue]

		def notify
			response = OpenPayU::Order.retrieve(params[:order][:orderId])
			order_info = response.parsed_data['orders']['orders'].first
			order = Spree::Order.find(order_info['extOrderId'])
			payment = order.payments.last

			payment.pend! if payment.checkout?

			case order_info['status']
			when 'PENDING'
				payment.failure!
			when 'CANCELLED'
				payment.void!
			when 'REJECTED'
				payment.failure!
			when 'COMPLETED'
				payment.complete!
			end

			render json: OpenPayU::Order.build_notify_response(response.req_id)
		end

		def continue
		end
	end
end