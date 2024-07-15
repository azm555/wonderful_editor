require 'rails_helper'

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) } #記事一覧取得:indexメソッドのpathへアクセスする
    before { 3.times { FactoryBot.create(:article) } } # FactoryBotを介して記事情報を3つ作成
    fit "記事の一覧が取得できる" do
      subject

      # 記事情報がすべて返ってきていること
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      # 返ってきた記事データがtitleのデータを持つこと
      expect(res[0].keys).to include "title"
      # ステータスコードが200であること
      expect(response).to have_http_status(200)

    end
  end
end
