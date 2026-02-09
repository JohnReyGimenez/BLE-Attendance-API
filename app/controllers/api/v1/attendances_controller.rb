module Api
  module V1
    class AttendancesController < ApplicationController
      # POST /api/v1/attendances
      def create
        # Find tag by its MAC address
        tag = Tag.find_by(mac_address: params[:mac_address])

        # If the tag is not linked to any student, reject it
        if tag.nil? || tag.student.nil?
          render json: { error: "Tag not linked to any student" }, status: :unprocessable_entity
          return
        end

        # Create attendance record for the linked student
        attendance = AttendanceRecord.new(
          student: tag.student,
          mac_address: params[:mac_address],
          event_type: params[:event_type],  # "entered" or "exited"
          timestamp: params[:timestamp]
        )

        if attendance.save
          render json: {
            message: "Attendance recorded successfully!",
            student: tag.student.name,
            event_type: attendance.event_type,
            timestamp: attendance.timestamp
          }, status: :created
        else
          render json: { errors: attendance.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/attendances
      def index
        records = AttendanceRecord.all
        render json: records
      end
    end
  end
end
