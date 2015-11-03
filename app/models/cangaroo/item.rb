module Cangaroo
  class Item < ActiveRecord::Base
    validates :item_type, :item_id, :payload, :connection, presence: true
    validates :item_id, uniqueness: { scope: :item_type }

    belongs_to :connection, foreign_key: :cangaroo_connection_id

    def created?
      created_at == updated_at
    end

    def updated?
      !created?
    end

    def payload=(new_payload)
      super(payload ? payload.deep_merge(new_payload) : new_payload)
    end

    def self.create_with!(attributes)
      attributes.deep_symbolize_keys!
      item = self.where(item_type: attributes[:item_type],
                 item_id: attributes[:payload][:id]).first_or_initialize
      item.payload = attributes[:payload]
      if item.new_record?
        item.connection = attributes[:connection]
      else
        item.touch
      end
      item.save!
      item
    end
  end
end
