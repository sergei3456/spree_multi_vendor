# frozen_string_literal: true

module Spree
  module ProductsControllerDecorator
    def vendor
      curr_page = params[:page] || 1
      @vendor = ::Spree::Vendor.includes(:products).find_by(slug: params[:slug])
      @products = @vendor.products.page(curr_page).per(9)
    end
  end
end

::Spree::ProductsController.prepend Spree::ProductsControllerDecorator
