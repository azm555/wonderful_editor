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

      def create
        # current_user（User.firstのユーザー）に紐づけられた新規記事のインスタンスを生成・保存する
        @article = current_user.articles.create!(article_params)
        render json: @article, each_serializer: ArticleSerializer
      end

      def update
        @article = Article.find(params[:id]) # 記事の取得
        @article.update!(article_params) # 記事の更新
        render json: @article, each_serializer: ArticleSerializer
      end

      def destroy
        @article = Article.find(params[:id]) # 記事の取得
        @article.destroy! # 記事の削除
        render json: @article, each_serializer: ArticleSerializer
      end

      private

        def article_params
          params.require(:article).permit(:title, :content)
        end
    end
  end
end
