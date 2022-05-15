class CreateClickStats < ActiveRecord::Migration[7.0]
  def change
    create_table :click_stats do |t|
      t.string :user_agent
      t.integer :clicks
      t.references :url, null: false, foreign_key: true

      t.timestamps
    end
  end
end
