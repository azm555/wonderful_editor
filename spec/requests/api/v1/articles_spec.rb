require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) } # 記事一覧取得:indexメソッドのpathへアクセスする（ルーティング確認）

    # before { 3.times { FactoryBot.create(:article) } } # FactoryBotを介して記事情報を3つ作成
    # before { create_list(:article, 3) } # FactoryBotのcreate_listメソッドを用いた記述に変更
    before { create_list(:article, article_count) } # letを用いた記述に変更

    let(:article_count) { 3 }

    # rubocop推奨のため、"記事の一覧が取得できる"テストを分割表示した
    it "記事情報がすべて返ってきていること" do
      subject
      res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
      expect(res.length).to eq 3
    end

    it "返ってきた記事データがtitleのデータを持つこと" do
      subject
      res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
      expect(res[0].keys).to include "title"
    end

    it "ステータスコードが200であること" do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) } # 記事詳細取得:showメソッドのpathへアクセスする（ルーティング確認）、詳細なのでidを指定するためarticle_id（letで定義した変数）を追記

    context "指定したidの記事が存在するとき" do
      let(:article_id) { article.id }
      let(:article) { FactoryBot.create(:article) }

      # rubocop推奨のため、"その記事のレコードが取得できる"というテストを2つに分割　"指定したidの記事データが返ってくること"と"ステータスコードが200であること"
      # さらに"指定したidの記事データが返ってくること"を2つに分割した
      it "指定したidの記事データのうちタイトルが返ってくること" do # リクエストデータと返ってきた記事データが一致すること
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # binding.pry
        expect(res["title"]).to eq article.title
      end

      it "指定したidの記事データのうち本文が返ってくること" do
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        expect(res["content"]).to eq article.content
      end

      it "ステータスコードが200であること" do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context "指定したidの記事が存在しないとき" do
      let(:article_id) { 100000 } # 被らないidを指定するため、大きい数値を記述した

      it "記事のレコードが見つからない" do
        # binding.pry
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
