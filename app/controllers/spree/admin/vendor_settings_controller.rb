# frozen_string_literal: true

module Spree
  module Admin
    class VendorSettingsController < Spree::Admin::BaseController
      before_action :authorize
      before_action :load_vendor

      def update
        @vendor.create_image(attachment: vendor_params[:image]) if vendor_params[:image] && Spree.version.to_f >= 3.6
        @vendor.create_image(attachment: vendor_params[:logo]) if vendor_params[:logo] && Spree.version.to_f >= 3.6
        if @vendor.update(vendor_params.except(:image)) && @vendor.update(vendor_params.except(:logo))
          redirect_to admin_vendor_settings_path
        else
          render :edit
        end
      end

      private

      def authorize
        authorize! :manage, :vendor_settings
      end

      def load_vendor
        @vendor = current_spree_vendor
        raise ActiveRecord::RecordNotFound unless @vendor
      end

      def vendor_params
        params.require(:vendor).permit(Spree::PermittedAttributes.vendor_attributes)
      end
    end
  end
end
