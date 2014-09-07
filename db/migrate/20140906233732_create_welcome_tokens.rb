class CreateWelcomeTokens < ActiveRecord::Migration
  def change
    create_table :welcome_tokens do |t|
      t.string :code

      t.timestamps
    end
  end
end
