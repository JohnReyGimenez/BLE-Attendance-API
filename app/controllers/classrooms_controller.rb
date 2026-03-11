class ClassroomsController < ApplicationController
  helper_method :get_event_time

  def index
    if params[:filter] == "archived"
      @classrooms = Classroom.where(archived: true)
      @current_filter = "archived"
    else
      @classrooms = Classroom.where(archived: false)
      @current_filter = "active"
    end

    @total_students = Student.count
    @present_today = AttendanceRecord.all.select { |r| (r.timestamp.to_date == Date.today rescue false) }.map(&:student_id).uniq.count
  end

  def show
    @classroom = Classroom.find(params[:id])
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    @students = @classroom.students.includes(:attendance_records)
    @attendance_data = AttendanceRecord.where(student_id: @students.pluck(:id)).select do |record|
      record.timestamp.to_date == @date rescue false
    end.group_by(&:student_id)
  end

  def new
    @classroom = Classroom.new
  end

  def create
    @classroom = Classroom.new(classroom_params)
    if @classroom.save
      redirect_to root_path, notice: "Classroom created successfully!"
    else
      render :new
    end
  end

  def archive
    @classroom = Classroom.find(params[:id])
    @classroom.update(archived: !@classroom.archived)
    redirect_to root_path, notice: "#{@classroom.name} archive status updated!"
  end

  def assign_student
    @classroom = Classroom.find(params[:id])

    student = Student.find_or_initialize_by(student_id_number: params[:student_id_number])

    if student.update(
         name: params[:name],
         mac_address: params[:mac_address],
         classroom: @classroom
       )
      redirect_to classroom_path(@classroom), notice: "#{student.name} was successfully assigned!"
    else
      redirect_to classroom_path(@classroom), alert: "Failed to assign student. Please check the fields."
    end
  end

  private

  def classroom_params
    params.require(:classroom).permit(:name)
  end

  def get_event_time(records, event_type)
    return "N/A" unless records
    record = records.find { |r| r.event_type == event_type }
    return "N/A" unless record && record.timestamp

    time = record.timestamp.is_a?(String) ? Time.parse(record.timestamp) : record.timestamp
    time.strftime("%I:%M %p")
  rescue
    "N/A"
  end
end
