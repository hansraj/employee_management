class CreateEmployeeDepartments < ActiveRecord::Migration
  def self.up
    create_table :employee_departments do |t|
      t.references :employee
      t.references :department
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_departments
  end
end
