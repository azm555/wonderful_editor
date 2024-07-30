require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do # 新規登録機能に関するテストの実装
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) } # createメソッドのpathへアクセスする（ルーティング確認）、paramsを送るためにparams設置（paramsは下記でそれぞれ定義する）

    context "適切なパラメーターを送信したとき" do
      # FactoryBotを用いて、ランダム生成されたname,email,passwordパラメーターを送る
      let(:params) do
        FactoryBot.attributes_for(:user)
      end

      it "新規ユーザーのレコードが1つ作成される" do
        # ユーザーのレコード数が1つ増える
        expect { subject }.to change { User.count }.by(1)
      end

      it "送ったパラメーターをもとにユーザーのレコード(nameカラム)が作成される" do
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # res(レスポンス)の値（実際に作成されたレコードのうち、nameカラム）とリクエストとして送ったパラメーター（let(:params)）の値が一致すること
        expect(res["data"]["name"]).to eq params[:name]
      end

      it "送ったパラメーターをもとに記事のレコード(emailカラム)が作成される" do
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # res(レスポンス)の値（実際に作成されたレコードのうち、emailカラム）とリクエストとして送ったパラメーター（let(:params)）の値が一致すること
        expect(res["data"]["email"]).to eq params[:email]
      end

      it "ステータスコードが200であること" do
        subject
        expect(response).to have_http_status(200)
      end

      it "header情報が返ってくる" do # access-tokenを指定する
        subject
        # binding.pry
        # response.headerでheader情報の参照が可能、response.header["access-token"]にてaccess-tokenを指定
        # access-tokenが存在することを確認する（be_validはバリデーション向けのため不可）
        expect(response.header["access-token"]).to be_present
      end
    end

    context "不適切なパラメーターを送信したとき" do
      let(:params) do # FactoryBotを用いて、ランダム生成されたパラメーターのうち、nameカラムが送られていない
        FactoryBot.attributes_for(:user, name: nil)
      end

      it "エラーする" do
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # エラー内容が一致すること
        # expect(response.status).to eq(422)
        expect(res["errors"]["name"]).to include("can't be blank") # res["errors"]["name"]が配列のため、マッチャーにeqが使用できない
      end
    end
  end
end
