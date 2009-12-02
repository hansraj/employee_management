require 'digest/sha1'

# A User is used to validate administrative staff. The class is
# complicated by the fact that on the application side it
# deals with plain-text passwords, but in the database it uses
# SHA1-hashed passwords.


class Employee < ActiveRecord::Base
 has_many :departments, :through => :employee_departments 
 has_many :employee_departments 
 belongs_to :designation
 has_many :time_sheets
 has_many :leaves
 has_many :employee_leave_status

 #has_one :user, :dependent => :destroy
 belongs_to :user, :dependent => :destroy
 validates_presence_of :first_name,  :office_email
 validates_uniqueness_of :first_name, :scope => :last_name
 validates_uniqueness_of  :office_email,:personal_email
 #validates_numericality_of :pan_number,:contact ,:passport_number 
 #validates_uniqueness_of  :employee_id 
 #validates_uniqueness_of :pan_number, :allow_blank => true
 #validates_uniqueness_of :passport_number, :allow_blank => true
 #~ validates_format_of :pan_number,
    #~ :with => /^((^[A-Z]{5}*$)+[0-9]{4}+[A-Z]{1})$/i
 #
  has_attached_file :photo,
    :styles => { :small_thumb => [ "50x50", :jpg ],  
            :medium_thumb => [ "75x75", :jpg ],
            :carousal => [ "100x100", :jpg ],
            :detail_preview => [ "210x210", :jpg ]},#size set according to picture size available in xhtmls(brands_review_detail.html)
    :url => "/images/layouts/:id/:style/:basename.:extension",
    :default_url => "public/images/layouts/:id/:style.jpg"
  validates_attachment_content_type :photo, :content_type => ['image/pjpeg','image/jpeg', 'image/png','image/x-png','image/gif'], :message=>"Invalid file format " 

  validates_format_of :office_email,
    :with => /^([^@]+)@((joshsoftware.)+[a-z]{2,})$/i
 validates_format_of :office_email,:personal_email,
    :with => /^([^@]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/i    
  before_destroy :delete
  
  def before_save        
    pan_number =  Employee.find_by_pan_number(self.pan_number) if !self.pan_number.blank?
    if  pan_number and !self.pan_number.blank? and self.id != pan_number.id
     errors.add( :pan_number, "has already been taken" ) 
     return false  
    end
    passport_number =  Employee.find_by_passport_number(self.passport_number) if !self.passport_number.blank?
    if  passport_number and !self.passport_number.blank? and self.id != passport_number.id
     errors.add( :passport_number, "has already been taken" ) 
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
