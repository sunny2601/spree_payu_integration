class PayuOrder
  include Rails.application.routes.url_helpers

  def self.params(order, ip, order_url, notify_url, continue_url)
    {
      merchant_pos_id: OpenPayU::Configuration.merchant_pos_id,
      customer_ip: ip,
      ext_order_id: order.id,
      description: I18n.t('order_description', name: Spree::Config.site_name),
      currency_code: 'PLN',
      total_amount: (order.total * 100).to_i,
      order_url: order_url,
      notify_url: notify_url,
      continue_url: continue_url,
      buyer: {
        email: order.email,
        phone: order.bill_address.phone,
        first_name: order.bill_address.firstname,
        last_name: order.bill_address.lastname,
        language: 'PL',
        delivery: {
          street: order.shipping_address.address1,
          postal_code: order.shipping_address.zipcode,
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