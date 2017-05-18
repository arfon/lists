class ListsController < ApplicationController
  def index
    @lists = policy_scope(List).paginate(:page => params[:page])

    respond_to do |format|
      format.html
      format.json { render :json => @lists }
    end
  end

  def show
    @list = List.find_by_sha(params[:id])

    authorize @list

    respond_to do |format|
      format.html 
      format.json { render :json => @list }
    end
  end
end
