module Spree
  module Integrations
    class GoogleMerchantFeed < Spree::Integration
      def self.integration_group
        'marketing'
      end

      def self.icon_path
        'integration_icons/google-merchant-center-logo.png'
      end
    end
  end
end
