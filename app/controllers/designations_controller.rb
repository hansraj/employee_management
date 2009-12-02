class DesignationsController < ApplicationController
  layout 'admin/home'

  def index
    @designations = Designation.all  
  end

  def new
    @designation  = Designation.new
  end
 
  def create
    @designation = Designation.new(params[:designation])
    @designation.save!
    
    redirect_to designations_path
  end

  def edit
    @designation = Designation.find(params[:id])
  end

  def update
    @designation = Designation.find(params[:id])
    @designation.update_attributes(params[:designation])

    redirect_to designations_path
  end

  def destroy
    Designation.find(params[:id]).destroy
    flash[:notice] = 'Designation was successfully deleted.'
    redirect_to designations_path 
  end
end
