Spree::Core::Engine.add_routes do
  get '/google_merchant/products', to: 'google_merchant_feed#products', defaults: { format: :xml }
  get '/google_merchant/products.xml.gz', to: 'google_merchant_feed#products'
end
