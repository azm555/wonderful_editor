# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Comment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  context "contentカラムを指定しているとき" do
    it "コメントが作成される" do
      FactoryBot.create(:user)
      # user = User.create!(name: "foo", password: "fooooo", email: "foo@example.com")
      FactoryBot.create(:article)
      # article = Article.create!(title: "abc", content: "abc", user: user)
      comment = FactoryBot.build(:comment)
      # comment = Comment.new(content: "abcabc", user: user, article: article)
      expect(comment).to be_valid
    end
  end

  context "contentカラムを指定していないとき" do
    it "コメント作成に失敗する" do
      FactoryBot.create(:user)
      # user = User.create!(name: "foo", password: "fooooo", email: "foo@example.com")
      FactoryBot.create(:article)
      # article = Article.create!(title: "abc", content: "abc", user: user)
      comment = FactoryBot.build(:comment, content: nil)
      # comment = Comment.new(content: nil, user: user, article: article)
      expect(comment).to be_invalid
      # expect(comment.errors.details[:content][0][:error]).to eq :blank
    end
  end
end
