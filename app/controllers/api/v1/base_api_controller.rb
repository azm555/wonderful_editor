module Api
  module V1
    class BaseApiController < ApplicationController
      # 仮実装用のコード
      # def current_user
      #   # usersテーブルの一番初めのユーザー情報を取ってくる
      #   @current_user = User.first
      #   binding.pry
      # end

      def current_user
        current_api_v1_user
      end

      def user_signed_in?
        api_v1_user_signed_in?
      end

      def authenticate_user!
        authenticate_api_v1_user!
      end
    end
  end
end
