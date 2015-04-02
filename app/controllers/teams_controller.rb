class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in

  # GET /teams
  # GET /teams.json
  def index
    @teams = current_user.recent_teams
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        @team.users << current_user
        render_success format, 'created', :created
      else
        render_errors format, @team.errors, :new
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        render_success format, 'updated', :ok
      else
        render_errors format, @team.errors, :edit
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = current_user.teams.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name)
  end

  def render_success(format, action, status)
    format.html { redirect_to @team, notice: "Team was successfully #{action}." }
    format.json { render :show, status: status, location: @team }
  end
end
