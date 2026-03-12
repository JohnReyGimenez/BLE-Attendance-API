module Api
  module V1
    class AttendancesController < ApplicationController
      # 1. The explicit command to stop the bouncer (matching your logs)
      skip_before_action :require_authentication, raise: false

      # 2. Rails 8 native way (just in case)
      allow_unauthenticated_access if respond_to?(:allow_unauthenticated_access)

      # 3. Disable browser token security for hardware
      skip_before_action :verify_authenticity_token

      # POST /api/v1/attendances
      def create
        # Find the student directly by their assigned MAC address
        student = Student.find_by(mac_address: params[:mac_address])

        # If no student is found with this MAC address, reject it
        if student.nil?
          render json: { error: "Unregistered MAC Address: #{params[:mac_address]}" }, status: :not_found
          return
        end

        # Create the attendance record
        attendance = AttendanceRecord.new(
          student: student,
          event_type: params[:event_type],
          timestamp: params[:timestamp] || Time.current
        )

        if attendance.save
          render json: {
            message: "Attendance recorded successfully!",
            student: student.name,
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
