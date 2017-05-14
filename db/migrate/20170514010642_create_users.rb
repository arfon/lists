class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string      :provider
      t.string      :uid
      t.string      :name
      t.string      :oauth_token
      t.string      :oauth_expires_at
      t.string      :email
      t.string      :sha
      t.hstore      :extra
      t.boolean     :admin, :default => false, :null => false
      t.timestamps  :null => false
    end
  end
end
