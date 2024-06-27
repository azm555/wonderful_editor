class Article < ApplicationRecord
  has_many :comments
  has_many :likes

  belongs_to :user

end
