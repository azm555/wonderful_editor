module Api
  module V1
    module Articles
      class DraftsController < Api::V1::BaseApiController
        # before_action :authenticate_user!

        def index
          # 下書きの記事を更新日順に取得する
          @articles = Article.draft.order("updated_at DESC")
          # binding.pry
          render json: @articles, each_serializer: ArticlePreviewSerializer
          # renderメソッド使用時に、デフォルトではない上記シリアライザーを指定した
        end

        def show
          # 指定したidの下書きの記事を取得する
          @article = Article.draft.find(params[:id])
          # binding.pry
          render json: @article, each_serializer: ArticleSerializer
        end
      end
    end
  end
end
