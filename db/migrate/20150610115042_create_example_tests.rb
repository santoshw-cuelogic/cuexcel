class CreateExampleTests < ActiveRecord::Migration
  def change
    create_table :example_tests do |t|
      t.string :name

      t.timestamps
    end
  end
end
