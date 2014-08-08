Spree::Core::Engine.routes.draw do
  post '/payu/notify', to: 'payu#notify'
end
