Spree::Core::Engine.routes.draw do
  get '/payu/notify', to: 'payu#notify'
  get '/payu/continue', to: 'payu#continue'
end
