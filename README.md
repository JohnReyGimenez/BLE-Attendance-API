# BLE Attendance API

This is the Ruby on Rails backend API for the BLE Attendance System. It is designed to:
* Manage student and BLE tag (beacon) data.
* Receive and log attendance data (entry/exit events) from the ESP32 scanner network.
* Provide data to the frontend dashboard.

---

## API Endpoints

This API provides RESTful endpoints for managing students, tags, and attendance records.

### Students

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/students` | List all students |
| `POST` | `/students` | Create a new student |
| `GET` | `/students/:id` | Show student info |
| `PATCH/PUT` | `/students/:id` | Update student |
| `DELETE` | `/students/:id` | Remove student |

### Tags

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/tags` | List all tags |
| `POST` | `/tags` | Assign or create new BLE tag |
| `PATCH/PUT` | `/tags/:id` | Update tag’s linked student |
| `DELETE` | `/tags/:id` | Remove or unassign tag |

### Attendances (ESP32 Route)

This is the primary endpoint for the ESP32 scanner to send data.

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/v1/attendances` | Retrieve all attendance records |
| `POST` | `/api/v1/attendances` | Record attendance via ESP32 |
| `PATCH/PUT` | `/api/v1/attendances/:id` | Update attendance record |

---

## ESP32 JSON Payload

To log an attendance event, the ESP32 (Scanner Node B) must send an HTTP POST request to `/api/v1/attendances` with a JSON body in the following format:

```json
{
  "mac_address": "D1:22:3A:4B:5C:6D",
  "event_type": "entered",
  "timestamp": "2025-10-27T14:30:00Z"
}
