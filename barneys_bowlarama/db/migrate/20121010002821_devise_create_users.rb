# encoding: utf-8

class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email, :default => ""
      t.string :encrypted_password, :default => ""

      ## Recoverable
      # t.string   :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      # t.string :authentication_token


      #t.string :role, :default => "user"
      t.string :role, :null => false

      t.string :first_name, :null => false
      t.string :last_name, :null => false

      t.string :phone, :null => false

      t.integer :bonus_count, :default => 0

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    # add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
 
    User.create do |u|
      u.email = "admin1@lv-bowling.com"
      u.password = "admin1"
      u.password_confirmation = "admin1"
      u.role = "admin"
      u.first_name = "Jan-Niklas"
      u.last_name = "Bartholomäus"
      u.phone = "123456"
    end

    User.create do |u|
      u.email = "cashier@lv-bowling.com"
      u.password = "cashier"
      u.password_confirmation = "cashier"
      u.role = "cashier"
      u.first_name = "Susi"
      u.last_name = "Sorglos"
      u.phone = "12345678"
    end

    User.create do |u|
      u.email = "user@lv-bowling.com"
      u.password = "testuser"
      u.password_confirmation = "testuser"
      u.role = "user"
      u.first_name = "Tom"
      u.last_name = "Tester"
      u.phone = "123456789"
    end

  end
end
