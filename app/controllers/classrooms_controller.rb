class ClassroomsController < ApplicationController
  def index
    if params[:filter] == "archived"
      @classrooms = Classroom.where(archived: true)
      @current_filter = "archived"
    else
      @classrooms = Classroom.where(archived: false)
      @current_filter = "active"
    end

    @total_students = Student.count
    @present_today = AttendanceRecord.where(timestamp: Date.today.all_day).select(:student_id).distinct.count
  end

  def show
    @classroom = Classroom.find(params[:id])
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    @students = @classroom.students.includes(:attendance_records)

    @attendance_data = AttendanceRecord.where(
      student_id: @students.pluck(:id),
      timestamp: @date.all_day
    ).group_by(&:student_id)
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
    @classroom.update(archived: true)
    redirect_to root_path, notice: "Classroom archived."
  end

  private

  def classroom_params
    params.require(:classroom).permit(:name)
  end

  def assign_student
    @classroom = Classroom.find(params[:id])

    student = Student.find_by(email: params[:identifier]) ||
              Student.find_by(student_id_number: params[:identifier])

    if student
      student.update(classroom: @classroom)
      redirect_to classroom_path(@classroom), notice: "#{student.name} was successfully assigned!"
    else
      redirect_to classroom_path(@classroom), alert: "Could not find a student with that ID or Email."
    end
  end
end
