require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do # ログイン機能に関するテストの実装
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) } # createメソッドのpathへアクセスする（ルーティング確認）、paramsを送るためにparams設置（paramsは下記でそれぞれ定義する）

    # Let!により、テスト実行前にFactoryBotを用いて、ランダム生成されたname,email,passwordパラメーターを送り、新規ユーザー登録を行う
    let!(:user) { FactoryBot.create(:user) }

    context "適切なパラメーターを送信したとき" do
      # 上記で生成された新規ユーザーのemail,passwordパラメーターをキーとバリューの形式で送る `user = FactoryBot.create(:user)`との考え方
      let(:params) do
        {
          email: user.email,
          password: user.password,
        }
      end

      it "header情報のうち、access-tokenが返ってくる" do
        subject
        # binding.pry
        # response.header["access-token"]にてaccess-tokenを指定
        # access-tokenが存在することを確認する（be_validはバリデーション向けのため不可）
        expect(response.header["access-token"]).to be_present
      end

      it "header情報のうち、clientが返ってくる" do
        subject
        # binding.pry
        # response.header["client"]にてclientを指定
        # clientが存在することを確認する（be_validはバリデーション向けのため不可）
        expect(response.header["client"]).to be_present
      end

      it "ステータスコードが200であること" do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context "不適切なパラメーターを送信したとき" do
      # 上記で生成された新規ユーザーのemail,passwordパラメーターのうち、email情報が送られない
      let(:params) do
        {
          password: user.password,
        }
      end

      it "エラーする" do
        subject
        res = response.parsed_body # res = JSON.parse(response.body) rubocopにより推奨
        # binding.pry
        # エラー内容が一致すること
        # expect(response.status).to eq(422)
        expect(res["errors"]).to include("Invalid login credentials. Please try again.") # res["errors"]が配列のため、マッチャーにeqが使用できない
      end
    end
  end
end
