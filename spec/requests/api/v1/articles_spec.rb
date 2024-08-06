require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) } # 記事一覧取得:indexメソッドのpathへアクセスする（ルーティング確認）

    before { 3.times { FactoryBot.create(:article, :published) } } # FactoryBotを介して記事情報を3つ作成
    # before { create_list(:article, 3) } # FactoryBotのcreate_listメソッドを用いた記述に変更
    # before { create_list(:article, article_count) } # letを用いた記述に変更

    # let(:article_count) { 3 }

    # rubocop推奨のため、"記事の一覧が取得できる"テストを分割表示した
    it "公開された記事情報がすべて返ってきていること" do
      subject
      res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
      expect(res.length).to eq 3
    end

    it "公開された記事のstatusがpublishedであること" do
      subject
      res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
      # binding.pry
      # 取得した記事のそれぞれのstatusがpublishedであること
      res.each do |article|
      expect(article["status"]).to eq "published"
      end
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

    context "指定したidの公開された記事が存在するとき" do
      let(:article_id) { article.id }
      let(:article) { FactoryBot.create(:article, :published) }

      # rubocop推奨のため、"その記事のレコードが取得できる"というテストを2つに分割　"指定したidの記事データが返ってくること"と"ステータスコードが200であること"
      # さらに"指定したidの記事データが返ってくること"を2つに分割した
      it "指定したidの公開された記事データのうちタイトルが返ってくること" do # リクエストデータと返ってきた記事データが一致すること
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # binding.pry
        expect(res["title"]).to eq article.title
      end

      it "指定したidの公開された記事データのうち本文が返ってくること" do
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        expect(res["content"]).to eq article.content
      end

      it "ステータスコードが200であること" do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context "指定したidの公開された記事が存在しないとき" do
      let(:article_id) { 100000 } # 被らないidを指定するため、大きい数値を記述した

      it "記事のレコードが見つからない" do
        # binding.pry
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }
    # createメソッドのpathへアクセスする（ルーティング確認）、paramsを送るためにparams設置（paramsは下記でそれぞれ定義する）、ログインユーザー判別のためにheaders設置

    context "適切なパラメーターを送信したとき" do
      # FactoryBotを用いて、ランダム生成されたtitle,contentパラメーターを、controllerのarticle_paramsにおけるparams.require(:article)に対応するようarticleキー（:article）に対するバリューの形式で送る
      let(:params) do
        { article: FactoryBot.attributes_for(:article) }
      end
      # ログインユーザー判別のためにheaders情報のうち、必要なトークン情報を送る
      let(:headers) do
        current_user.create_new_auth_token
      end

      # Letにより、テスト実行前にFactoryBotを用いて、ランダム生成されたname,email,passwordパラメーターを送り、新規ユーザー登録を行う
      let(:current_user) { FactoryBot.create(:user) }

      # 上記ユーザー情報のうち、email,password情報を用いてログインする（header情報の発行）、ログイン機能のテスト参照
      before do
        post(api_v1_user_session_path, params: { email: current_user.email, password: current_user.password })
      end

      it "記事のレコードが1つ作成される" do
        # 記事のレコード数が1つ増える
        expect { subject }.to change { Article.count }.by(1)
      end

      it "送ったパラメーターをもとに記事のレコード(titleカラム)が作成される" do
        # current_user_mock = FactoryBot.create(:user)
        # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # res(レスポンス)の値（実際に作成されたレコードのうち、titleカラム）とリクエストとして送ったパラメーター（let(:params)）の値が一致すること
        expect(res["title"]).to eq params[:article][:title]
      end

      it "送ったパラメーターをもとに記事のレコード(contentカラム)が作成される" do
        # current_user_mock = FactoryBot.create(:user)
        # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # res(レスポンス)の値（実際に作成されたレコードのうち、contentカラム）とリクエストとして送ったパラメーター（let(:params)）の値が一致すること
        expect(res["content"]).to eq params[:article][:content]
      end

      it "送ったパラメーターをもとに記事のレコード(statusカラム)が作成される" do
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # res(レスポンス)の値（実際に作成されたレコードのうち、statusカラム）とリクエストとして送ったパラメーター（let(:params)）の値が一致すること
        expect(res["status"]).to eq params[:article][:status]
      end

      it "ステータスコードが200であること" do
        # current_user_mock = FactoryBot.create(:user)
        # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

        subject
        expect(response).to have_http_status(200)
      end
    end

    context "不適切なパラメーターを送信したとき" do
      let(:params) do # FactoryBotを用いて、ランダム生成されたtitle,contentパラメーターをarticleキー（:article）に対応しない形式で送る
        FactoryBot.attributes_for(:article)
      end
      # ログインユーザー判別のためにheaders情報のうち、必要なトークン情報を送る
      let(:headers) do
        current_user.create_new_auth_token
      end

      # Letにより、テスト実行前にFactoryBotを用いて、ランダム生成されたname,email,passwordパラメーターを送り、新規ユーザー登録を行う
      let(:current_user) { FactoryBot.create(:user) }

      # 上記ユーザー情報のうち、email,password情報を用いてログインする（header情報の発行）、ログイン機能のテスト参照
      before do
        post(api_v1_user_session_path, params: { email: current_user.email, password: current_user.password })
      end

      it "エラーする" do
        # current_user_mock = FactoryBot.create(:user)
        # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article_id), params: params, headers: headers) }
    # 更新対象の記事情報取得:updateメソッドのpathへアクセスする（ルーティング確認）、idを指定するためarticle_id（letで定義した変数）を追記、paramsを送るためにparams設置（paramsは下記でそれぞれ定義する）

    # FactoryBotを用いて、記事情報をランダムに生成しておく
    let(:article_id) { article.id }
    # ログインユーザー判別のためにheaders情報のうち、必要なトークン情報を送る
    let(:headers) do
      current_user.create_new_auth_token
    end
    # 公開された記事を作成する
    let(:article) { FactoryBot.create(:article, :published) }

    # 上記でidを指定して呼び出した記事に更新するパラメーターを送る
    # controllerのarticle_paramsにおけるparams.require(:article)に対応するようarticleキー（:article）に対するバリューの形式で送る
    let(:params) do
      { article: { title: "タイトル更新1", created_at: 1.day.ago } }
    end

    # Letにより、テスト実行前にFactoryBotを用いて、ランダム生成されたname,email,passwordパラメーターを送り、新規ユーザー登録を行う
    let(:current_user) { FactoryBot.create(:user) }

    # 上記ユーザー情報のうち、email,password情報を用いてログインする（header情報の発行）、ログイン機能のテスト参照
    before do
      post(api_v1_user_session_path, params: { email: current_user.email, password: current_user.password })
    end

    it "指定したidの記事のレコードのうち送ったパラメーターのみ（titleカラム）更新される" do
      # # createメソッドと同様にモックを使用
      # current_user_mock = FactoryBot.create(:user)
      # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

      # 指定したidの記事のtitleカラムが送ったパラメーターに変わる（更新される）
      expect { subject }.to change { Article.find(article_id).title }.from(article.title).to(params[:article][:title])
    end

    it "指定したidの記事のレコードのうち送っていないパラメーター（contentカラム）は変わらない" do
      # current_user_mock = FactoryBot.create(:user)
      # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

      # 指定したidの記事のcontentカラムが変わらない
      expect { subject }.not_to change { Article.find(article_id).content }
    end

    it "指定したidの記事のレコードのうち送っていないパラメーター（statusカラム）は変わらない" do
      # 指定したidの記事のstatusカラムが変わらない
      expect { subject }.not_to change { Article.find(article_id).status }
    end

    it "指定したidの記事のレコードのうち書き換え不可のパラメーター（created_atカラム）は変わらない" do
      # current_user_mock = FactoryBot.create(:user)
      # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_mock)

      # 指定したidの記事のcreated_atカラムが変わらない
      expect { subject }.not_to change { Article.find(article_id).created_at }
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }
    # 削除対象の記事情報取得:destroyメソッドのpathへアクセスする（ルーティング確認）、idを指定するためarticle_id（letで定義した変数）を追記

    # FactoryBotを用いて、記事情報をランダムに生成しておく
    let(:article_id) { article.id } # 上記(article_id)をletで定義する
    # ログインユーザー判別のためにheaders情報のうち、必要なトークン情報を送る
    let(:headers) do
      current_user.create_new_auth_token
    end
    let!(:article) { FactoryBot.create(:article) } # 上記articleをletで定義する

    # Letにより、テスト実行前にFactoryBotを用いて、ランダム生成されたname,email,passwordパラメーターを送り、新規ユーザー登録を行う
    let(:current_user) { FactoryBot.create(:user) }

    # 上記ユーザー情報のうち、email,password情報を用いてログインする（header情報の発行）、ログイン機能のテスト参照
    before do
      post(api_v1_user_session_path, params: { email: current_user.email, password: current_user.password })
    end

    it "指定したidの記事のレコードが削除される" do
      expect { subject }.to change { Article.count }.by(-1)
    end
  end
end
