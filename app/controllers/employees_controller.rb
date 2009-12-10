class EmployeesController < ApplicationController
  #before_filter :checkadmin, :except => [:index, :edit,:update, :show]
  layout 'admin/home'

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
    @roles = Role.find(:all).collect { |role|  ["#{role.title}", role.id ] }
  end

  def select_department
    @departments = Department.find(:all).collect { |department| ["#{department.name}", department.id ] }
  end

  def select_designation
    @designations = Designation.find(:all).collect { |designation| ["#{designation.name}", designation.id ] }
  end

  def index
    #@employee_pages, @employees = paginate :employees, :order => "employee_id ASC", :per_page => 10
    @employees = Employee.find(:all)
    if current_user.role.title != "Admin"
      employee = Employee.find_by_user_id(current_user)
      if employee.blank?
        redirect_to '/404.html' 
        return
      end
      redirect_to employee_path(employee.id) 
    end
  end

  def show
    select_role
    @employee = Employee.find(params[:id])
  end

  def new
    @employee = Employee.new
    select_role
    select_department
    select_designation
  end

  def create
    select_role
    select_department
    select_designation
    params[:employee].delete('image_file') if params[:employee][:image_file].blank?
    @employee = Employee.new(params[:employee])
    if @employee.save
      #@employee_leave_status= EmployeeLeaveStatus.new
      #     @employee_leave_status.employee_id = @employee.id
      #     @employee_leave_status.year = Time.now.strftime("%Y").to_i
      #     @employee_leave_status.save
      add_employee_department(@employee, params[:department][:id])
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
    select_designation
  end

  def update
    select_department
    select_role
    select_designation
    @employee = Employee.find(params[:id])
    #params[:employee].delete('employee_id') if ( session[:rolename] != "admin" and params[:employee][:employee_id] )
    #params[:employee].delete('image_file') if params[:employee][:image_file].blank?
    if not params[:department].blank?
      add_employee_department(@employee.id, params[:department][:id])
    end
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

  def add_employee_department(emp_id, dept_id)
    emp_dept = EmployeeDepartment.find_emp_dept(emp_id, dept_id)
    if emp_dept.blank? 
      emp_dept = EmployeeDepartment.new("employee_id" => emp_id, "department_id" => dept_id )
      emp_dept.save!
    elsif
      emp_dept.first.department_id = dept_id
      emp_dept.first.save!
    end
  end
end
