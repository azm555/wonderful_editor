class AddUserIdToArticles < ActiveRecord::Migration[6.1]
  def change
    add_reference :articles, :user, foreign_key: true

    # articlesテーブルに新たにstatus（記事の状態を表す）カラムを追加する
    # integer型、カラム生成時の値は空のため、null: falseとし、デフォルト値は0（draft）とした
    add_column :articles, :status, :integer, default: 0, null: false
  end
end
