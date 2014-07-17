class PayuOrder
	
	CURRENCY = ['PLN']

	include ActiveModel::Validations

	attr_accessor :merchant_pos_id, :customer_ip, :ext_order_id, :order_url,
		:description, :currency_code

	validates :merchant_pos_id,
		presence: true,
		numericality: { only_integer: true }
	validates :customer_ip,
		presence: true
	validates :ext_order_id,
		presence: true
	validates :order_url,
		presence: true
	validates :description,
		presence: true
	validates :currency_code,
		inclusion: { in: CURRENCY }

end