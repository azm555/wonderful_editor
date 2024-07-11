# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  content    :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  context "titleカラム及びcontentカラムを指定しているとき" do
    it "記事が作成される" do
      FactoryBot.create(:user)
      # user = User.create!(name: "foo", password: "fooooo", email: "foo@example.com")
      article = FactoryBot.build(:article)
      # article = user.articles.new(title: "abc", content: "abc")
      expect(article).to be_valid
    end
  end

  context "titleカラム及びcontentカラムを指定していないとき" do
    it "記事作成に失敗する" do
      FactoryBot.create(:user)
      # user = User.create!(name: "foo", password: "fooooo", email: "foo@example.com")
      article = FactoryBot.build(:article, title: nil, content: nil)
      # article = user.articles.new(title: nil, content: nil)
      expect(article).to be_invalid
      # expect(article.errors.details[:title][0][:error]).to eq :blank
      # expect(article.errors.details[:content][0][:error]).to eq :blank
    end
  end

  context "titleカラムを指定していないとき" do
    it "記事作成に失敗する" do
      FactoryBot.create(:user)
      # user = User.create!(name: "foo", password: "fooooo", email: "foo@example.com")
      article = FactoryBot.build(:article, title: nil)
      # article = user.articles.new(title: nil)
      expect(article).to be_invalid
      # expect(article.errors.details[:title][0][:error]).to eq :blank
    end
  end

  context "contentカラムを指定していないとき" do
    it "記事作成に失敗する" do
      FactoryBot.create(:user)
      # user = User.create!(name: "foo", password: "fooooo", email: "foo@example.com")
      article = FactoryBot.build(:article, content: nil)
      # article = user.articles.new(content: nil)
      expect(article).to be_invalid
      # expect(article.errors.details[:content][0][:error]).to eq :blank
    end
  end
end
