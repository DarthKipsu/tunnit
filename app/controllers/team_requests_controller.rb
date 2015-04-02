class TeamRequestsController < ApplicationController
  before_action :set_team, only: [:new, :create]

  # GET teams/1/add_member
  def new
    @errors = []
  end

  # POST /teams
  # POST /teams.json
  def create
    @team_request = TeamRequest.for_email(request_params['email'], @team.id, current_user.id)

    respond_to do |format|
      if @team_request.save
        format.html { redirect_to @team, notice: 'Request to join the team was sent!' }
        format.json { render :show, status: :sent, location: @team }
      else
        render_errors format, @team_request.errors, :new
      end
    end
  end

  private
  def set_team
    @team = current_user.teams.find(params[:id])
  end

  def request_params
    params.permit(:email)
  end
end
