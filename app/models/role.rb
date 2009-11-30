class Role < ActiveRecord::Base
validates_presence_of :role_name
validates_uniqueness_of :role_name
end
