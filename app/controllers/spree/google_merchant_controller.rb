module Spree
  class GoogleMerchantController < StoreController
    include BaseHelper
    include StorefrontHelper

    def products
      respond_to do |format|
        format.xml
        format.gzip do
          gz_xml = ActiveSupport::Gzip.compress(render_to_string(template: 'spree/google_merchant/products', formats: [:xml]))
          send_data(gz_xml, filename: 'sitemap.xml.gz', type: 'application/x-gzip', disposition: 'inline')
        end
      end
    end
  end
end
