module Api
  module V1
    class BaseApiController < ApplicationController
      # 仮実装用のコード
      def current_user
        # usersテーブルの一番初めのユーザー情報を取ってくる
        @current_user = User.first
        # binding.pry
      end
    end
  end
end
