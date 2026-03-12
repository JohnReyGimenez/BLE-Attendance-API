module Api
  module V1
    class AttendancesController < ApplicationController
      # 1. The official Rails 8 way to bypass the login screen
      allow_unauthenticated_access

      # 2. Disable browser token security for the ESP32
      skip_before_action :verify_authenticity_token

      # POST /api/v1/attendances
      def create
        student = Student.find_by(mac_address: params[:mac_address])

        if student.nil?
          render json: { error: "Unregistered MAC: #{params[:mac_address]}" }, status: :not_found
          return
        end

        attendance = AttendanceRecord.new(
          student: student,
          event_type: params[:event_type],
          timestamp: params[:timestamp] || Time.current
        )

        if attendance.save
          render json: {
            message: "Success!",
            student: student.name,
            event_type: attendance.event_type
          }, status: :created
        else
          render json: { errors: attendance.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
