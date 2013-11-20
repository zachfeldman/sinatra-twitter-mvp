class CreateTweets < ActiveRecord::Migration
  def up
    create_table :tweets do |t|
      t.string :text
      t.integer :user_id
      t.datetime :created_at
    end
  end

  def down
    drop_table :tweets
  end
end
