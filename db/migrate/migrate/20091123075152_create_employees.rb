class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :employee_id 
      t.string :first_name 
      t.string :last_name 
      t.date :date_of_birth
      t.date :date_of_joining
      t.string :qualification
      t.integer :year_of_passing
      t.references :designation
      t.string :office_email
      t.string :personal_email
      t.string :mobile
      t.string :landline 
      t.text :current_address
      t.text :permanent_address
      t.string :pan_number
      t.string :passport_number
      t.date :passport_exp_date
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
