class ProjectsController < ApplicationController
  include ReportHelper
  before_action :ensure_that_signed_in
  before_action :set_project, only: [:show, :edit, :hours, :update, :destroy, :report]
  before_action :set_teams, only: [:new, :edit, :create, :update]
  before_action :set_allocation, only: [:allocate, :deallocate]

  # GET /projects/new
  def new
    @project = Project.new
    if params[:team] then @project.team_id = params[:team] end
  end

  # GET /projects/1/edit
  def edit
  end

  # GET /projects/1/show
  def show
    @total_hours = @project.total_hours_used
    @allocation = Allocation.new
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        @project.team.touch
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        render_errors(format, @project.errors, :new)
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        @project.team.touch
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        render_errors(format, @project.errors, :edit)
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST projects/allocate
  def allocate
    if @allocation.nil?
      @allocation = Allocation.new(allocation_params)
    else
      @allocation.update(allocation_params)
    end

    if @allocation.save
      redirect_to :back, notice: "#{params[:alloc_hours]} hours allocated for #{params[:name]}"
    else
      flash[:error] = "Error in hours format, nothing allocated!"
      redirect_to :back
    end
  end

  # DELETE projects/allocate
  def deallocate
    @allocation.destroy
    redirect_to :back, notice: "Allocations for #{params[:name]} removed"
  end

  # GET /projects/1/generate_report
  def report
    create_report_for params, @project
  end

  private
  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :team_id)
  end

  def allocation_params
    params.permit(:user_id, :project_id, :alloc_hours)
  end

  def set_teams
    @teams = current_user.teams.all
  end

  def set_allocation
    @allocation = Allocation.find_by project_id:params[:project_id], user_id:params[:user_id]
  end
end
