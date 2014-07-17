Spree::CheckoutController.class_eval do

  before_filter :pay_with_payu, only: :update

  private

  def pay_with_payu
    return unless params[:state] == 'payment'

    @payment_method = Spree::PaymentMethod.find(
      params[:order][:payments_attributes].first[:payment_method_id]
    )
    @shipment = @order.shipments.first
    @shipping_rate = @shipment.shipping_rates.where(selected: true).first

    if @payment_method && @payment_method.kind_of?(Spree::PaymentMethod::Payu)
      @response = OpenPayU::Order.create(
        payu_order_params(@order, request)
      )

      case @response.status['status_code']
      when 'SUCCESS'
        redirect_to @response.redirect_uri
      else
        @order.errors[:base] << "PayU error: #{@response['status_code']}"
        render :edit
      end
    end

  rescue StandardError => e
    @order.errors[:base] << "PayU error: #{e.message}"
    render :edit
  end

  def payu_order_params(order, request)
    {
      merchant_pos_id: OpenPayU::Configuration.merchant_pos_id,
      customer_ip: request.remote_ip,
      ext_order_id: order.id,
      description: I18n.t('order_description', name: Spree::Config.site_name),
      currency_code: 'PLN', # TODO: can we use more langs with PayU?
      total_amount: (order.total * 100).to_i,
      order_url: order_url(order),
      notify_url: payu_notify_url,
      continue_url: payu_continue_url,
      buyer: {
        email: order.email,
        phone: order.bill_address.phone,
        first_name: order.bill_address.firstname,
        last_name: order.bill_address.lastname,
        language: 'PL', # TODO: can we use other languages?
        delivery: {
          street: order.shipping_address.address1,
          postal_code: @order.shipping_address.zipcode,
          city: order.shipping_address.city,
          country_code: order.bill_address.country.iso
        }
      },
      products: order.line_items.map { |li|
        {
          name: li.product.name,
          unit_price: (li.price * 100).to_i,
          quantity: li.quantity
        }
      }
    }
  end

end
