xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.rss version: "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    cache current_store do
      xml.title current_store.name
      xml.link root_url
      xml.description current_store.meta_description
    end

    cache [storefront_products_scope, current_currency] do
      storefront_products_scope.find_each do |product|
        xml.item do
          # Basic product data
          xml.tag! "g:id", product.id
          xml.tag! "g:title", product.name.truncate(150)
          xml.tag! "g:description", product.storefront_description&.truncate(5000)
          xml.tag! "g:link", spree_storefront_resource_url(product)
          if product.default_image.present?
            xml.tag! "g:image_link", spree_image_url(product.featured_image, width: 500, height: 500)
          end

          # Price and availability
          xml.tag! "g:availability", product.in_stock? ? "in_stock" : "out_of_stock"
          xml.tag! "g:availability_date", product.available_on.strftime("%Y-%m-%dT%H:%M%z") if product.available_on?
          xml.tag! "g:expiration_date", product.discontinue_on.strftime("%Y-%m-%dT%H:%M%z") if product.discontinue_on?
          xml.tag! "g:price", format('%.2f', product.display_amount.to_d) + " " + current_currency
        
          # Product category
          xml.tag! "g:product_type", product_breadcrumb_taxons(product).map(&:name).join(' > ')

          # Product identifiers
          xml.tag! "g:brand", product.brand.name if product.brand.present?
          xml.tag! "g:gtin", product.sku

          # Detailed product description
          xml.tag! "g:product_weight", "#{product.weight}#{product.weight_unit}" if product.weight.present?
        end
      end
    end
  end
end
