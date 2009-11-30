require 'digest/sha1'

# A User is used to validate administrative staff. The class is
# complicated by the fact that on the application side it
# deals with plain-text passwords, but in the database it uses
# SHA1-hashed passwords.


class Employee < ActiveRecord::Base
 belongs_to :department
 belongs_to :role
 has_many :time_sheets
 has_many :leaves
 has_many :employee_leave_status
 has_one :user, :dependent => :destroy
 validates_presence_of :first_name, :title, :department_id, :office_email
 validates_uniqueness_of :first_name, :scope => :last_name
 validates_uniqueness_of  :office_email,:personal_email
 #validates_numericality_of :pan_no,:contact ,:passport_no 
 #validates_uniqueness_of  :employee_id 
 #validates_uniqueness_of :pan_no, :allow_blank => true
 #validates_uniqueness_of :passport_no, :allow_blank => true
 #~ validates_format_of :pan_no,
    #~ :with => /^((^[A-Z]{5}*$)+[0-9]{4}+[A-Z]{1})$/i

  validates_format_of :office_email,
    :with => /^([^@]+)@((joshsoftware.)+[a-z]{2,})$/i
 validates_format_of :office_email,:personal_email,
    :with => /^([^@]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/i    
  before_destroy :delete
  
  def before_save        
    pan_no =  Employee.find_by_pan_no(self.pan_no) if !self.pan_no.blank?
    if  pan_no and !self.pan_no.blank? and self.id != pan_no.id
     errors.add( :pan_no, "has already been taken" ) 
     return false  
    end
    passport_no =  Employee.find_by_passport_no(self.passport_no) if !self.passport_no.blank?
    if  passport_no and !self.passport_no.blank? and self.id != passport_no.id
     errors.add( :passport_no, "has already been taken" ) 
     return false  
   end    
   employee_id =  Employee.find_by_employee_id(self.employee_id) if !self.employee_id.blank?
    if  employee_id and !self.employee_id.blank? and self.id != employee_id.id
     errors.add( :employee_id, "has already been taken" ) 
     return false  
    end    
  end
  
   def image_file=(input_data)
     #~ self.filename = input_data.original_filename
     #~ self.content_type = input_data.content_type.chomp
     self.photo = input_data.read
   end
  
  def delete
      if Employee.count.zero?
        raise "Can't delete last Employee"
      end
      b=Employee.find(:first, :conditions =>"first_name='gautam' and role_id='1'")
      if(b)
        errors.add('You are not authorized to delete ') 
      end    
  end

  def self.birthday
    employees = Employee.find( :all )
    employees.each{ |emp| 
      if emp.dob.day == Time.today.day and emp.dob.month == Time.today.month 
        if birthday
          birthday = birthday<<", "<<"HaPpY BiRthdaY"<<emp.first_name 
        else
          birthday = "HaPpY BiRthdaY"<<emp.first_name 
        end
      elsif emp.dob.month == Time.today.month and Time.today.day < emp.dob.day
        if birthday
          birthday = birthday<<","<<emp.first_name<<"'s Birthday is on "<<emp.dob.strftime("%d %B") 
        else
          birthday = " "<<emp.first_name<<"'s Birthday is on "<<emp.dob.strftime("%d %B") 
        end
      end
    }
    return birthday
  end

end
