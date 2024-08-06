module Api
  module V1
    class ArticlePreviewSerializer < ActiveModel::Serializer
      attributes :id, :title, :updated_at, :status

      has_many :comments
      has_many :likes

      belongs_to :user
    end
  end
end
