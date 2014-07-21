Spree::CheckoutController.class_eval do

  before_filter :pay_with_payu, only: :update

  private

  def pay_with_payu
    return unless params[:state] == 'payment'

    payment_method = Spree::PaymentMethod.find(
      params[:order][:payments_attributes].first[:payment_method_id]
    )
    shipment = @order.shipments.first
    shipping_rate = shipment.shipping_rates.where(selected: true).first

    if payment_method && payment_method.kind_of?(Spree::PaymentMethod::Payu)
      response = OpenPayU::Order.create(
        PayuOrder.params(@order, request.remote_ip,
          order_url(@order), payu_notify_url, payu_continue_url)
      )

      case response.status['status_code']
      when 'SUCCESS'
        persist_user_address

        payment = @order.payments.build(
          payment_method_id: payment_method.id,
          amount: @order.total,
          state: 'checkout'
        )

        unless payment.save
          flash[:error] = payment.errors.full_messages.join("\n")
          redirect_to checkout_state_path(@order.state) and return
        end

        unless @order.next
          flash[:error] = @order.errors.full_messages.join("\n")
          redirect_to checkout_state_path(@order.state) and return
        end

        payment.pend!

        redirect_to response.redirect_uri
      else
        @order.errors[:base] << "PayU error: #{@response['status_code']}"
        render :edit
      end
    end

  rescue StandardError => e
    @order.errors[:base] << "PayU error: #{e.message}"
    render :edit
  end

end
