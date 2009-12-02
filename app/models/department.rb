class Department < ActiveRecord::Base
 has_many :employees, :through => :employee_departments 
 has_many :employee_departments 
 validates_uniqueness_of :name
end
