class EmployeesController < ApplicationController
#before_filter :checkadmin, :except => [:index, :edit,:update, :show]
layout "vendor/plugins/employee_management/app/views/layouts/home.html.erb"

  def code_image
    @image_data = Employee.find(params[:id])
    send_data(@image_data.photo, :type     => "image/jpeg",
                      :filename => "photo.jpg",
                      :disposition => 'inline')
  end 

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => :post, :only => [ :destroy, :create, :update ],
  #         :redirect_to => { :action => :list }

  def select_role
    @roles = Role.find(:all).collect { |role|  ["#{role.role_name}", role.id ] }
  end
  
  def select_department
     @departments = Department.find(:all).collect { |department| ["#{department.department_name}", department.id ] }
  end
  
  def index
#@employee_pages, @employees = paginate :employees, :order => "employee_id ASC", :per_page => 10
    @employees = Employee.find(:all)
  end

  def show
    select_role
    @employee = Employee.find(params[:id])
  end

def new
    @employee = Employee.new
    select_role
    select_department
end

def create
  select_role
  select_department
   params[:employee].delete('image_file') if params[:employee][:image_file].blank?
   @employee = Employee.new(params[:employee])
   if @employee.save
#@employee_leave_status= EmployeeLeaveStatus.new
#     @employee_leave_status.employee_id = @employee.id
#     @employee_leave_status.year = Time.now.strftime("%Y").to_i
#     @employee_leave_status.save
     flash[:notice] = 'Employee was successfully created.'
     redirect_to( :action => 'index')
       else
      render :action => 'new'
   end
end

  
  def edit
    @employee = Employee.find(params[:id])
    select_role
    select_department
  end

  def update
    select_department
    select_role
    @employee = Employee.find(params[:id])
    params[:employee].delete('employee_id') if ( session[:rolename] != "admin" and params[:employee][:employee_id] )
    params[:employee].delete('image_file') if params[:employee][:image_file].blank?
    if @employee.update_attributes(params[:employee])
      flash[:notice] = 'Employee was successfully updated.'
      redirect_to employee_path(@employee)
    else

      render :action => 'edit'
    end
  end

  
  def destroy
    Employee.find(params[:id]).destroy
    flash[:notice] = 'Employee was successfully deleted.'
    redirect_to employees_path 
  end
  
end
