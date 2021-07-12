class HomeController < ApplicationController
  def index
    @customer_info = CustomerProductRelationship.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer_info }
    end
  end
end
