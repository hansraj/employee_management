class Department < ActiveRecord::Base
validates_uniqueness_of :department_name
end
