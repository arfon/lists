class CreateThings < ActiveRecord::Migration[5.1]
  def change
    create_table :things do |t|
      t.hstore      :properties
      t.string      :sha
      t.integer     :list_id
      t.timestamps
    end
  end
end
