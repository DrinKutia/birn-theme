# app/controllers/admin_censor_rule_controller.rb:
# For modifying requests.
#
# Copyright (c) 2008 UK Citizens Online Democracy. All rights reserved.
# Email: hello@mysociety.org; WWW: http://www.mysociety.org/

class AdminCensorRuleController < AdminController

  before_action :set_editor, :only => [:create, :update]
  before_action :set_censor_rule, :only => [:edit, :update, :destroy]
  before_action :set_subject_and_censor_rule_and_form_url, :only => [:new, :create]

  def index
    @censor_rules = CensorRule.global
  end

  def new
  end

  def create
    if @censor_rule.save
      flash[:notice] = 'Censor rule was successfully created.'
      expire_requests_and_redirect
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @censor_rule.update(censor_rule_params)
      flash[:notice] = 'Censor rule was successfully updated.'
      expire_requests_and_redirect
    else
      render :action => 'edit'
    end
  end

  def destroy
    info_request = @censor_rule.info_request
    user = @censor_rule.user
    @censor_rule.destroy

    flash[:notice] = "Censor rule was successfully destroyed."

    expire_requests_and_redirect
  end

  private

  # The subject can be @info_request, @censor_user or @public_body if the rule
  # applies to an associated record. Nothing is set for a global rule.
  def set_subject_and_censor_rule_and_form_url
    if params[:request_id]
      @info_request = InfoRequest.find(params[:request_id])
      @censor_rule = @info_request.censor_rules.build(censor_rule_params)
      @form_url = admin_request_censor_rules_path(@info_request)
    end

    if params[:user_id]
      @censor_user = User.find(params[:user_id])
      @censor_rule = @censor_user.censor_rules.build(censor_rule_params)
      @form_url = admin_user_censor_rules_path(@censor_user)
    end

    if params[:body_id]
      @public_body = PublicBody.find(params[:body_id])
      @censor_rule = @public_body.censor_rules.build(censor_rule_params)
      @form_url = admin_body_censor_rules_path(@public_body)
    end

    if [:request_id, :user_id, :body_id].all? { |key| params[key].nil? }
      @censor_rule = CensorRule.new(censor_rule_params)
      @form_url = admin_censor_rules_path
    end
  end

  def set_editor
    params[:censor_rule][:last_edit_editor] = admin_current_user
  end

  def set_censor_rule
    @censor_rule = CensorRule.find(params[:id])
  end

  def censor_rule_params
    if params[:censor_rule]
      params.require(:censor_rule).
        permit(:regexp, :text, :replacement, :last_edit_comment, :last_edit_editor)
    else
      {}
    end
  end

  def expire_requests_and_redirect
    @censor_rule.expire_requests

    if @censor_rule.info_request
      redirect_to admin_request_url(@censor_rule.info_request)
    elsif @censor_rule.user
      redirect_to admin_user_url(@censor_rule.user)
    elsif @censor_rule.public_body
      redirect_to admin_body_url(@censor_rule.public_body)
    else
      redirect_to admin_censor_rules_path
    end
  end
end
