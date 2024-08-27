require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/drafts" do
    subject {
      get(api_v1_articles_drafts_path, headers: headers)
    } # 記事一覧取得:indexメソッドのpathへアクセスする（ルーティング確認）、認証に必要なheaders情報である4つ（access-token,client,expiry,uid）を英クエストとして送る

    let(:user) { FactoryBot.create(:user) } # ユーザーを作成
    let!(:articles) { 3.times { FactoryBot.create(:article, :draft, user: user) } } # FactoryBotを介して下書きの記事を3つ作成し、ユーザーに関連付ける

    let(:headers) { user.create_new_auth_token } # 認証に必要なheaders情報である4つ（access-token,client,expiry,uid）を取得する

    # rubocop推奨のため、"記事の一覧が取得できる"テストを分割表示した
    it "下書きの記事情報がすべて返ってきていること" do
      # binding.pry
      subject
      res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
      # binding.pry
      expect(res.length).to eq 3
    end

    it "下書きの記事のstatusがdraftであること" do
      subject
      res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
      # binding.pry
      # 取得した記事のそれぞれのstatusがdraftであること
      res.each do |article|
        expect(article["status"]).to eq "draft"
      end
    end

    it "ステータスコードが200であること" do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /api/v1/articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) } # 記事詳細取得:showメソッドのpathへアクセスする（ルーティング確認）、詳細なのでidを指定するためarticle_id（letで定義した変数）を追記

    let(:user) { FactoryBot.create(:user) } # ユーザーを作成
    let(:headers) { user.create_new_auth_token } # 認証に必要なheaders情報である4つ（access-token,client,expiry,uid）を取得する
    let(:article) { FactoryBot.create(:article, :draft, user: user) } # FactoryBotを介して下書きの記事を作成し、ユーザーに関連付ける
    let(:article_id) { article.id } # 作成した記事のIDをarticle_idに入れる、定義する

    context "指定したidの下書きの記事が存在するとき" do
      # rubocop推奨のため、"その記事のレコードが取得できる"というテストを2つに分割　"指定したidの記事データが返ってくること"と"ステータスコードが200であること"
      # さらに"指定したidの記事データが返ってくること"を2つに分割した
      it "指定したidの下書きの記事データのうちタイトルが返ってくること" do # リクエストデータと返ってきた記事データが一致すること
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # binding.pry
        expect(res["title"]).to eq article.title
      end

      it "指定したidの下書きの記事データのうち本文が返ってくること" do
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        expect(res["content"]).to eq article.content
      end

      it "ステータスコードが200であること" do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context "指定したidの下書きの記事が存在しないとき" do
      let(:article_id) { 100000 } # 被らないidを指定するため、大きい数値を記述した

      it "記事のレコードが見つからない" do
        # binding.pry
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
