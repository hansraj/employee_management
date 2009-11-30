class RolesController < ApplicationController
#before_filter :checkadmin
layout "vendor/plugins/employee_management/app/views/layouts/home.html.erb"
  
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #  verify :method => :post, :only => [ :destroy, :create, :update ],
  #         :redirect_to => { :action => :list }

  def index
# @role_pages, @roles = paginate :roles, :per_page => 7
  @roles = Role.find(:all)
  end

  def show
    @role = Role.find(params[:id])
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = 'Role was successfully created.'
      redirect_to roles_path 
    else
      render :action => 'new'
    end
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:notice] = 'Role was successfully updated.'
      redirect_to roles_path 
    else
      render :action => 'edit'
    end
  end

  def destroy
    Role.find(params[:id]).destroy
    redirect_to roles_path 
  end
end
