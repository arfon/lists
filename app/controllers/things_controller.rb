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

  def filter
    authorize @list.things.first

    query_string = sanitize_query_fields
    @things = @list.filter_things_with(query_string).paginate(:page => params[:page])

    respond_to do |format|
      format.json { render :json => @things }
    end
  end

  private

  # Filters the incoming query parameters and drops those query strings not
  # included in the parent List property keys
  def sanitize_query_fields
    allowed_fields = @list.property_index_keys
    return request.query_parameters.select {|key, val| allowed_fields.include?(key)}
  end

  def load_list
    @list = List.find_by_sha(params[:list_id])
  end
end
