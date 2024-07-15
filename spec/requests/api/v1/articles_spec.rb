require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) } # 記事一覧取得:indexメソッドのpathへアクセスする

    before { 3.times { FactoryBot.create(:article) } } # FactoryBotを介して記事情報を3つ作成

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
end
