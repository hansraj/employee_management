class CreateHierarchies < ActiveRecord::Migration
  def self.up
    create_table :hierarchies do |t|
      t.interger :employee_id
      t.integer :report_to # refer to the employee table
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :hierarchies
  end
end
