# frozen_string_literal: true

module Spree
  class Vendor < Spree::Base
    extend FriendlyId

    acts_as_paranoid
    acts_as_list column: :priority
    friendly_id :name, use: %i[slugged history]

    validates :name,
              presence: true,
              uniqueness: { case_sensitive: false }

    validates :facebook, url: true, allow_blank: true
    validates :twitter, url: true, allow_blank: true
    validates :instagram, url: true, allow_blank: true
    validates :vk, url: true, allow_blank: true
    validates :inn, presence: true, numericality: { only_integer: true }
    # TODO: добавить валидацию телефона
    validates :phone, presence: true

    validates :slug, uniqueness: true
    validates_associated :image if Spree.version.to_f >= 3.6
    validates_associated :logo if Spree.version.to_f >= 3.6

    validates :notification_email, email: true, allow_blank: true

    with_options dependent: :destroy do
      if Spree.version.to_f >= 3.6
        has_one :image, as: :viewable, dependent: :destroy, class_name: 'Spree::VendorImage'
        has_one :logo, as: :viewable, dependent: :destroy, class_name: 'Spree::VendorLogo'
      end
      has_many :commissions, class_name: 'Spree::OrderCommission'
      has_many :option_types
      has_many :products
      has_many :properties
      has_many :shipping_methods
      has_many :stock_locations
      has_many :variants
      has_many :vendor_users
    end

    has_many :users, through: :vendor_users

    after_create :create_stock_location
    after_update :update_stock_location_names

    state_machine :state, initial: :pending do
      event :activate do
        transition to: :active
      end

      event :block do
        transition to: :blocked
      end
    end

    scope :active, lambda {
      where(state: 'active')
    }

    self.whitelisted_ransackable_attributes = %w[name state]

    def update_notification_email(email)
      update(notification_email: email)
    end

    # Spree Globalize support
    # https://github.com/spree-contrib/spree_multi_vendor/issues/104
    if defined?(SpreeGlobalize)
      attr_accessor :translations_attributes
      translates :name,
                 :about_us,
                 :contact_us,
                 :slug, fallbacks_for_empty_translations: true
    end

    private

    def create_stock_location
      stock_locations.where(name: name, country: Spree::Country.default).first_or_create!
    end

    def should_generate_new_friendly_id?
      slug.blank? || name_changed?
    end

    def update_stock_location_names
      if (Spree.version.to_f < 3.5 && name_changed?) || (Spree.version.to_f >= 3.5 && saved_changes&.include?(:name))
        stock_locations.update_all({ name: name })
      end
    end
  end
end
