module FormHelper
  def render_errors(format, errors, form)
    format.html { render form }
    format.json { render json: @event.errors, status: :unprocessable_entity }
  end
end
