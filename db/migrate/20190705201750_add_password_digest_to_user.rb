class AddPasswordDigestToUser < ActiveRecord::Migration[5.2]
  def change
    # rails g migration add_password_digest_to_user password_digest
    add_column :users, :password_digest, :string
  end
end
