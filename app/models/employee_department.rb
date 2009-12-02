class EmployeeDepartment < ActiveRecord::Base
  belongs_to :employee
  belongs_to :department
  named_scope :find_emp_dept, lambda { |emp_id, dept_id| { :conditions => ["employee_id = ? and department_id = ?",emp_id, dept_id] } }
end
