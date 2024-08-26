require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path) } # 記事一覧取得:indexメソッドのpathへアクセスする（ルーティング確認）

    before { 3.times { FactoryBot.create(:article, :published) } } # FactoryBotを介して公開の記事情報を3つ作成

    # rubocop推奨のため、"記事の一覧が取得できる"テストを分割表示した
    it "公開の記事情報がすべて返ってきていること" do
      # binding.pry
      subject
      res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
      # binding.pry
      expect(res.length).to eq 3
    end

    it "公開の記事のstatusがpublishedであること" do
      subject
      res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
      # binding.pry
      # 取得した記事のそれぞれのstatusがpublishedであること
      res.each do |article|
        expect(article["status"]).to eq "published"
      end
    end

    it "ステータスコードが200であること" do
      subject
      expect(response).to have_http_status(200)
    end
  end
end
