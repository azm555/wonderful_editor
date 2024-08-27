class Api::V1::Current::ArticlesController < Api::V1::BaseApiController
  before_action :authenticate_user!

  def index
    # 公開記事を更新日順に取得する
    @articles = current_user.articles.published.order("updated_at DESC")
    # binding.pry
    render json: @articles, each_serializer: Api::V1::ArticleSerializer
    # renderメソッド使用時に、デフォルトではない上記シリアライザーを指定した
  end
end
