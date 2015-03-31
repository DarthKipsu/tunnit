class EventsController < ApplicationController
  include DateHelper
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in

  # GET /events
  # GET /events.json
  def index
    @events = current_user.events.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @projects = current_user.projects.all
  end

  # GET /events/1/edit
  def edit
    @projects = current_user.projects.all
  end

  # POST /events
  # POST /events.json
  def create
    begin
      start = DateTime.parse(params[:start]) 
    rescue
      return redirect_to new_event_path, alert: "Incorrect start time"
    end
    endTime = start + parseDuration(params[:time]).minutes
    title = current_user.projects.find_by_id(params[:project]).name
    @event = Event.new(start: start, end: endTime, project_id: params[:project], title: title)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        @projects = current_user.projects.all
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        @projects = current_user.projects.all
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = current_user.events.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:start, :time, :project)
    end
end
