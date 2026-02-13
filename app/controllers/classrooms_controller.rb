class GroupsController < ApplicationController
  def index
    # Find all unique Block names to display as "Groups"
    # Example result: ["Block A", "Block B", "Science 101"]
    @blocks = Student.select(:block).distinct.pluck(:block).compact.sort
  end

  def show
    @block_name = params[:id]

    @date = params[:date] ? Date.parse(params[:date]) : Date.current

    @students = Student.where(block: @block_name).order(:name)
    @attendance_data = AttendanceRecord.where(
      student_id: @students.pluck(:id),
      timestamp: @date.all_day
    ).group_by(&:student_id)
  end
end
