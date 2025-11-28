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

          if product.featured_image.present?
            xml.tag! "g:image_link", spree_image_url(product.featured_image, width: 500, height: 500)
          end
          product.master_images.each do |image|
            next if product.featured_image == image

            xml.tag! "g:additional_image_link" do
              xml.cdata! spree_image_url(image, width: 500, height: 500)
            end
          end

          # Price and availability
          if product.in_stock?
            xml.tag! "g:availability", "in_stock"
          elsif product.backorderable?
            xml.tag! "g:availability", "backorder"
          elsif !product.in_stock?
            xml.tag! "g:availability", "out_of_stock"
          end

          xml.tag! "g:availability_date", product.available_on.strftime("%Y-%m-%dT%H:%M%z") if product.available_on?
          xml.tag! "g:expiration_date", product.discontinue_on.strftime("%Y-%m-%dT%H:%M%z") if product.discontinue_on?

          if product.on_sale?(current_store.default_currency)
            xml.tag! "g:price", format('%.2f', product.display_compare_at_price.to_d) + " " + current_currency
            xml.tag! "g:sale_price", format('%.2f', product.display_price.to_d) + " " + current_currency
          else
            xml.tag! "g:price", format('%.2f', product.display_price.to_d) + " " + current_currency
          end

          # Product category
          xml.tag! "g:product_type", product_breadcrumb_taxons(product).map(&:name).join(' > ')

          # Product identifiers
          xml.tag! "g:brand", product.brand_taxon.name if product.brand_taxon.present?

          # Detailed product description
          xml.tag! "g:product_weight", "#{product.weight} #{product.weight_unit}" if product.weight.present?

          # Shipping
          xml.tag! "g:shipping_weight", "#{product.weight} #{product.weight_unit}" if product.weight.present?
        end
      end
    end
  end
end
