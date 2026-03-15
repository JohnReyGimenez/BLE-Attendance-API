# AttendanceHub: BLE Attendance System

AttendanceHub is a full-stack Ruby on Rails 8 application and IoT hardware network designed to automate classroom attendance using Bluetooth Low Energy (BLE). 

Instead of manual roll calls, students carry nRF52 BLE tags. An ESP32 scanner deployed in the classroom detects when tags enter or exit the room and syncs this data to the website.

## Features

* **Full-Stack Web Dashboard:** Teachers can manage classrooms, assign BLE tags to students, and view daily attendance records.
* **Smart Time Aggregation:** Automatically calculates a student's absolute earliest "entered" time and latest "exited" time per day, handling mid-day signal drops.
* **Offline Hardware Syncing:** With an internal flash storage, such is the case when the classroom Wi-Fi drops or is unavailable, the ESP32 locally caches attendance records and background-syncs them to the server once the connection is restored.


---

### Record Attendance
* **Endpoint:** `POST /api/v1/attendances`

**Expected JSON Payload:**
```json
{
  "mac_address": "DF:52:C3:E8:8F:64",
  "event_type": "entered",
}
