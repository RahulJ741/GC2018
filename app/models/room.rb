class Room < ApplicationRecord
  belongs_to :hotel
  has_many :rooms_features, dependent: :destroy
  has_many :features ,:through => :rooms_features
  has_one :shopping_cart
  # has_one :user,through: :shopping_cart
  # belongs_to :shopping_cart


  scope :rooms_type, -> (rooms_type) { where rooms_type: rooms_type }
  scope :room_size, -> (room_size) { where room_size: room_size }
  scope :max_occupancy, -> (max_occupancy) { where max_occupancy: max_occupancy }
  scope :hotel_id, -> (hotel_id) { where hotel_id: hotel_id }
  # scope :rooms_type, -> (rooms_type) { where rooms_type: rooms_type }
end
