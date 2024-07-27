module Api
  module V1
    class ArticleSerializer < ActiveModel::Serializer
      attributes :id, :title, :content

      has_many :comments
      has_many :likes

      belongs_to :user
    end
  end
end
