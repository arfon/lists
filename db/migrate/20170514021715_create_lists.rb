class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.string      :name
      t.string      :sha
      t.text        :description
      t.jsonb       :properties
      t.integer     :user_id
      t.boolean     :visible, :default => false, :null => false
      t.timestamps
    end
  end
end
