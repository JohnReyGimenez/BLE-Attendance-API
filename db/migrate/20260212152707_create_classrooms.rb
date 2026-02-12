class CreateClassrooms < ActiveRecord::Migration[8.0]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.boolean :archived

      t.timestamps
    end
  end
end
