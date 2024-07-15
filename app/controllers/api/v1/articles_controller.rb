module Api
  module V1
    class ArticlesController < Api::V1::BaseApiController
      def index
        @articles = Article.order("updated_at DESC")
        # binding.pry
        render json: @articles, each_serializer: ArticlePreviewSerializer
      end
    end
  end
end
