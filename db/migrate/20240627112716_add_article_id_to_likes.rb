class AddArticleIdToLikes < ActiveRecord::Migration[6.1]
  def change
    add_reference :likes, :article, foreign_key: true
  end
end
