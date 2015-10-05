class DropArticles < ActiveRecord::Migration
  def up
    drop_table :articles
  end
  def down
    create_table :articles do |t|
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
