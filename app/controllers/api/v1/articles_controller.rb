module Api
  module V1
    class ArticlesController < Api::V1::BaseApiController
      def index
        @articles = Article.order("updated_at DESC")
        # binding.pry
        render json: @articles, each_serializer: ArticlePreviewSerializer
        # renderメソッド使用時に、デフォルトではない上記シリアライザーを指定した
      end

      def show
        @article = Article.find(params[:id])
        # binding.pry
        render json: @article, each_serializer: ArticleSerializer
      end

      private

        def article_params
          params.require(:article).permit(:title, :content)
        end
    end
  end
end
