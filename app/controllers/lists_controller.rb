class ListsController < ApplicationController
  def index
    @lists = List.visible.paginate(:page => params[:page])

    respond_to do |format|
      format.json { render :json => @lists }
    end
  end

  def show
    @list = List.find_by_sha(params[:id])

    authorize @list, :show

    respond_to do |format|
      format.json { render :json => @list }
    end
  end
end
