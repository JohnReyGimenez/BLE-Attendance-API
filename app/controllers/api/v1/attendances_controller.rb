module Api
  module V1
    class AttendancesController < ApplicationController
      allow_unauthenticated_access
      skip_before_action :verify_authenticity_token

      def create
        clean_mac = params[:mac_address].to_s.strip.upcase
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
          mac_address: clean_mac, # <--- The missing puzzle piece!
          event_type: params[:event_type],
          timestamp: params[:timestamp].presence || Time.current
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
