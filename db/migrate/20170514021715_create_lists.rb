class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.string      :name
      t.string      :sha
      t.text        :description
      t.string      :doi
      t.jsonb       :properties
      t.integer     :user_id
      t.boolean     :visible, :default => false, :null => false
      t.timestamps
    end

    add_index :lists, :properties, using: :gin
    add_index :lists, :sha, unique: true
    add_index :lists, :doi, unique: true
    add_index :lists, :user_id
  end
end
