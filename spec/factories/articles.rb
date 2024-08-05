# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  content    :text
#  status     :integer          default("draft"), not null
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :article do
    sequence(:title) {|n| "記事タイトル#{n}" }
    sequence(:content) {|n| "記事本文#{n}" }
    user
    # association :user, factory: :user

    trait :draft do
      status { :draft }
    end

    trait :published do
      status { :published }
    end
  end
end
