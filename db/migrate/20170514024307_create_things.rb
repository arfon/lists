class CreateThings < ActiveRecord::Migration[5.1]
  def change
    create_table :things do |t|
      t.jsonb      :properties
      t.string     :sha
      t.integer    :list_id
      t.timestamps
    end

    add_index :things, :properties, using: :gin
    add_index :things, :sha, unique: true
    add_index :things, :list_id
  end
end
