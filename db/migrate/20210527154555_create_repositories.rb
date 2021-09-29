class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :program
      t.string :scm_platform
      t.integer :program_id
      t.string :scm_url

      t.timestamps
    end
  end
end
