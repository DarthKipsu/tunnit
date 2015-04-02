class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:new, :create]

  # GET /users/1
  # GET /users/1.json
  def show
    @requests = current_user.pending_requests
    flash.now[:notice] = @requests[:message]
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        team = Team.create(name: 'Personal projects')
        @user.teams << team
        session[:user_id] = @user.id
        render_success format, 'created', :created
      else
        render_errors(format, @user.errors, :new)
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        render_success format, 'updated', :ok
      else
        render_errors(format, @user.errors, :edit)
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to signin_path, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:forename, :surname, :email, :password, :password_confirmation)
  end

  def render_success(format, action, status)
    format.html { redirect_to @user, notice: "Team was successfully #{action}." }
    format.json { render :show, status: status, location: @user }
  end
end
