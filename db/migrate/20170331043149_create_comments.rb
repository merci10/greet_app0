class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.text :content
      t.references :note, foreign_key: true

      t.timestamps
    end
    add_index :comments, [:note_id, :created_at]
    add_index :comments, :user_id
  end
end
