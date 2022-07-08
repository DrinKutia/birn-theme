class AdminPublicBodyChangeRequestsController < AdminController
  before_action :set_change_request, only: [:edit, :update]

  def edit
    @title = 'Close change request'
  end

  def update
    @change_request.close!

    if params[:subject] && params[:response]
      @change_request.send_response(params[:subject], params[:response])
      flash[:notice] =
        'The change request has been closed and the user has been notified'
    else
      flash[:notice] = 'The change request has been closed'
    end

    redirect_to admin_general_index_path
  end

  private

  def set_change_request
    @change_request = PublicBodyChangeRequest.find(params[:id])
  end
end
