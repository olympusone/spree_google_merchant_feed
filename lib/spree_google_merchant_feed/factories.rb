FactoryBot.define do
  factory :google_merchant_feed_integration, class: Spree::Integrations::GoogleMerchantFeed do
    active { true }
    store { Spree::Store.default }
  end
end
