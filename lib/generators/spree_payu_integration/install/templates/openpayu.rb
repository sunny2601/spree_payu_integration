require 'openpayu'

OpenPayU::Configuration.configure do |config|
  config.merchant_pos_id  = '145227'
  config.signature_key    = '13a980d4f851f3d9a1cfc792fb1f5e50'
  config.algorithm        = 'MD5'
  config.service_domain   = 'payu.com'
  config.protocol         = 'https'
  config.env              = 'secure'
  config.order_url        = 'http://localhost:3000/order'
  config.notify_url       = 'http://localhost:3000/notify'
  config.continue_url     = 'http://localhost:3000/success'
end
