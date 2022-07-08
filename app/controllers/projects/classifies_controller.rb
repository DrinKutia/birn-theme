require_dependency 'project/queue'

# Classify a request in a Project
class Projects::ClassifiesController < Projects::BaseController
  before_action :authenticate

  def show
    authorize! :read, @project

    @queue = Project::Queue.classifiable(@project, session)
    @info_request = @queue.next

    unless @info_request
      if @project.info_requests.classifiable.any?
        msg = _('Nice work! How about having another try at the requests you ' \
                'skipped?')
        @queue.reset
      else
        msg = _('There are no requests to classify right now. Great job!')
      end

      redirect_to @project, notice: msg
      return
    end

    @state_transitions = @info_request.state.transitions(
      is_pro_user: false,
      is_owning_user: false,
      in_internal_review: @info_request.described_state == 'internal_review',
      user_asked_to_update_status: false
    )
  end

  # Skip a request
  def update
    authorize! :read, @project

    info_request =
      @project.info_requests.find_by!(url_title: params.require(:url_title))

    queue = Project::Queue.classifiable(@project, session)
    queue.skip(info_request)

    redirect_to project_classify_path(@project), notice: _('Skipped!')
  end

  private

  def authenticate
    authenticated? || ask_to_login(
      web: _('To join this project'),
      email: _('Then you can join this project'),
      email_subject: _('Confirm your account on {{site_name}}',
                       site_name: site_name)
    )
  end
end
