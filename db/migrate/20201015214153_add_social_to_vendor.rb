# frozen_string_literal: true

class AddSocialToVendor < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_vendors, :facebook, :string
    add_column :spree_vendors, :twitter, :string
    add_column :spree_vendors, :instagram, :string
    add_column :spree_vendors, :vk, :string
    add_column :spree_vendors, :inn, :string
    add_column :spree_vendors, :phone, :string
    add_column :spree_vendors, :rating, :float, default: 0
    add_column :spree_vendors, :rating_count, :integer, default: 0
  end
end
