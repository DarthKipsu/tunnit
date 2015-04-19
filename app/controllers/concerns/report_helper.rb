module ReportHelper
  def create_report_for params, subject
    @start = DateTime.parse params[:start_time]
    @end = DateTime.parse params[:end_time]
    @hours = subject.hours_between(@start, @end)
    render layout: false
  end
end
