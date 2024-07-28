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

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params) } # createメソッドのpathへアクセスする（ルーティング確認）、paramsを送るためにparams設置（paramsは下記でそれぞれ定義する）

    context "適切なパラメーターを送信したとき" do
      # FactoryBotを用いて、ランダム生成されたtitle,contentパラメーターを、controllerのarticle_paramsにおけるparams.require(:article)に対応するようarticleキー（:article）に対するバリューの形式で送る
      let(:params) do
        { article: FactoryBot.attributes_for(:article) }
      end

      it "記事のレコードが1つ作成される" do
        # モックを用いてcurrent_userが呼ばれたときに持ってくるデータを指定する
        # 今回は適当なユーザー情報（FactoryBotでランダム生成）を指定する？
        current_user_mock = FactoryBot.create(:user)
        # Api::V1::BaseApiControllerクラスの全インスタンスに対して、current_userメソッドが呼ばれたときにモックを返すようにする
        # allow_any_instance_of(実装を置き換えたいオブジェクト).to receive(置き換えたいメソッド名).and_return(返却したい値やオブジェクト)
        allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

        # 記事のレコード数が1つ増える
        expect { subject }.to change { Article.count }.by(1)
      end

      it "送ったパラメーターをもとに記事のレコード(titleカラム)が作成される" do
        current_user_mock = FactoryBot.create(:user)
        allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # res(レスポンス)の値（実際に作成されたレコードのうち、titleカラム）とリクエストとして送ったパラメーター（let(:params)）の値が一致すること
        expect(res["title"]).to eq params[:article][:title]
      end

      it "送ったパラメーターをもとに記事のレコード(contentカラム)が作成される" do
        current_user_mock = FactoryBot.create(:user)
        allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # res(レスポンス)の値（実際に作成されたレコードのうち、contentカラム）とリクエストとして送ったパラメーター（let(:params)）の値が一致すること
        expect(res["content"]).to eq params[:article][:content]
      end

      it "ステータスコードが200であること" do
        current_user_mock = FactoryBot.create(:user)
        allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

        subject
        expect(response).to have_http_status(200)
      end
    end

    context "不適切なパラメーターを送信したとき" do
      let(:params) do # FactoryBotを用いて、ランダム生成されたtitle,contentパラメーターをarticleキー（:article）に対応しない形式で送る
        FactoryBot.attributes_for(:article)
      end

      it "エラーする" do
        current_user_mock = FactoryBot.create(:user)
        allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject {
      patch(api_v1_article_path(article_id), params: params)
    } # 記事更新情報取得:updateメソッドのpathへアクセスする（ルーティング確認）、idを指定するためarticle_id（letで定義した変数）を追記、paramsを送るためにparams設置（paramsは下記でそれぞれ定義する）

    # FactoryBotを用いて、記事情報をランダムに生成しておく
    let(:article_id) { article.id }
    let(:article) { FactoryBot.create(:article) }

    # 上記でidを指定して呼び出した記事に更新するパラメーターを送る
    # controllerのarticle_paramsにおけるparams.require(:article)に対応するようarticleキー（:article）に対するバリューの形式で送る
    let(:params) do
      { article: { title: "タイトル更新1", created_at: 1.day.ago } }
    end

    it "指定したidの記事のレコードのうち送ったパラメーターのみ（titleカラム）更新される" do
      # createメソッドと同様にモックを使用
      current_user_mock = FactoryBot.create(:user)
      allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

      # 指定したidの記事のtitleカラムが送ったパラメーターに変わる（更新される）
      expect { subject }.to change { Article.find(article_id).title }.from(article.title).to(params[:article][:title])
    end

    it "指定したidの記事のレコードのうち送っていないパラメーター（contentカラム）は変わらない" do
      current_user_mock = FactoryBot.create(:user)
      allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

      # 指定したidの記事のcontentカラムが変わらない
      expect { subject }.not_to change { Article.find(article_id).content }
    end

    it "指定したidの記事のレコードのうち書き換え不可のパラメーター（created_atカラム）は変わらない" do
      current_user_mock = FactoryBot.create(:user)
      allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

      # 指定したidの記事のcreated_atカラムが変わらない
      expect { subject }.not_to change { Article.find(article_id).created_at }
    end
  end
end
