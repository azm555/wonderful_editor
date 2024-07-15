module Api
  module V1
    class ArticlePreviewSerializer < ActiveModel::Serializer
      attributes :id, :title

      has_many :comments
      has_many :likes

      belongs_to :user
    end
  end
end
