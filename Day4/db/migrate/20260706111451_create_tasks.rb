class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :completed, null: false, default: false
      t.references :project, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
