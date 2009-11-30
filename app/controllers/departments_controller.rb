class DepartmentsController < ApplicationController
layout "vendor/plugins/employee_management/app/views/layouts/home.html.erb"

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def index
# @department_pages, @departments = paginate :departments, :per_page => 10
  @departments = Department.find(:all)
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(params[:department])
    if @department.save
      flash[:notice] = 'Department was successfully created.'
      redirect_to departments_path 
    else
      render :action => 'new'
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    if @department.update_attributes(params[:department])
      flash[:notice] = 'Department was successfully updated.'
      redirect_to departments_path 
    else
      render edit_department_path 
    end
  end

  def destroy
    Department.find(params[:id]).destroy
    redirect_to departments_path 
  end
end
