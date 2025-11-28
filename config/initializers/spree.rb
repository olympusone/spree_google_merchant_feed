Rails.application.config.after_initialize do
  Spree.integrations << Spree::Integrations::GoogleMerchantFeed
end
