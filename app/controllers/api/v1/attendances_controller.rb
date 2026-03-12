module Api
  module V1
    class AttendancesController < ApplicationController
      # 1. The official Rails 8 way to bypass the login screen
      allow_unauthenticated_access

      # 2. Disable browser token security for the ESP32
      skip_before_action :verify_authenticity_token

      # POST /api/v1/attendances
      def create
        # Clean the input: remove spaces and make it uppercase to match the DB
        clean_mac = params[:mac_address].to_s.strip.upcase

        # Find student by the cleaned MAC address
        student = Student.find_by(mac_address: clean_mac)

        if student.nil?
          render json: {
            error: "Unregistered MAC: #{clean_mac}",
            received_params: params.to_unsafe_h
          }, status: :not_found
          return
        end

        attendance = AttendanceRecord.new(
          student: student,
          event_type: params[:event_type],
          # Ensure a timestamp is always present
          timestamp: params[:timestamp].presence || Time.current
        )

        if attendance.save
          render json: {
            message: "Success!",
            student: student.name,
            event_type: attendance.event_type
          }, status: :created
        else
          # This will output the exact validation error in your Kamal logs
          render json: { errors: attendance.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
