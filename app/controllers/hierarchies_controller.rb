class HierarchiesController < ApplicationController
  layout 'admin/home'

  def index
    @hierarchies = Hierarchy.all
  end

  def new 
    @hierarchy = Hierarchy.new
  end

  def create
    @hierarchy = Hierarchy.new(params[:hierarchy])
    @hierarchy.save!

    redirect_to hierarchies_path
  end

  def destroy
    Hierarchy.find(params[:id]).destroy

    redirect_to hierarchies_path
  end
   
end
