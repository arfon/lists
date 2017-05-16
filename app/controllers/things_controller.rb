class ThingsController < ApplicationController
  before_action :load_list

  def index
    @things = @list.things.paginate(:page => params[:page])

    authorize @things.first

    respond_to do |format|
      format.json { render :json => @things }
    end
  end

  def show
    @thing = @list.things.find_by_sha(params[:id])

    authorize @thing

    respond_to do |format|
      format.json { render :json => @thing }
    end
  end

  private

  def load_list
    @list = List.find_by_sha(params[:list_id])
  end
end
