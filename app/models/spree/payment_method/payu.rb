module Spree
  class PaymentMethod::Payu < PaymentMethod
    def payment_profiles_supported?
      false
    end
  end
end
