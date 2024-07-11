# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  context "nameカラムを指定しているとき" do
    it "ユーザーが作成される" do
      # binding.pry
      user = FactoryBot.build(:user)
      # user = User.new(name: "foo", password: "fooooo", email: "foo@example.com")
      expect(user).to be_valid
    end
  end

  context "nameカラムを指定していないとき" do
    it "ユーザー作成に失敗する" do
      user = FactoryBot.build(:user, name: nil)
      # nameカラムを指定していないのでnilとした
      # user = User.new(password: "fooooo", email: "foo@example.com")
      expect(user).to be_invalid
      # expect(user.errors.details[:name][0][:error]).to eq :blank
    end
  end

  # context "まだ同じ名前のnameカラムが存在していないとき" do
  #   it "ユーザーが作成される" do
  #     user = User.new(name: "foo", password: "fooooo", email: "foo@example.com")
  #     expect(user).to be_valid
  #   end
  # end
  # 1つめのテストと同じため実装の必要なし

  # context "すでに同じ名前のnameカラムが存在しているとき" do
  #   it "ユーザー作成に失敗する" do
  #     FactoryBot.create(:user, name: "foo")
  #     # User.create!(name: "foo", password: "fooooo", email: "foo@example.com")
  #     user = FactoryBot.build(:user, name: "foo")
  #     # user = User.new(name: "foo", password: "barbar", email: "bar@example.com")

  #     expect(user).to be_invalid
  #     # binding.pry
  #     expect(user.errors.details[:name][0][:error]).to eq :taken
  #   end
  # end
end
