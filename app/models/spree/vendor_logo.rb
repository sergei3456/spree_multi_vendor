# frozen_string_literal: true

module Spree
  class VendorLogo < Asset
    include Spree::Image::Configuration::ActiveStorage
    include Rails.application.routes.url_helpers

    def styles
      self.class.styles.map do |_, size|
        width, height = size[/(\d+)x(\d+)/].split('x')
        {
          url: polymorphic_path(attachment.variant(resize: size), only_path: true),
          width: width,
          height: height
        }
      end
    end
  end
end
