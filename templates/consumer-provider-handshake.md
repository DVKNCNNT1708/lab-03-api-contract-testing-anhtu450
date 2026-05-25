# Consumer–Provider Handshake

## Thông tin chung

- Lab: FIT4110 Lab 03
- Ngày: 2026-05-20
- Provider team: team-iot (IoT Ingestion)
- Consumer team: team-notify (Notification)
- Provider service: IoT Ingestion API
- Consumer service: Smart Campus Notification API (Nhóm 16)


## Contract

- Contract file: contracts/iot-ingestion.openapi.yaml
- Mock base URL: http://127.0.0.1:4010 (Prism mock)
- Auth method: Bearer JWT (Authorization: Bearer {{authToken}})
- Endpoint được test: POST /readings, GET /readings/latest


## Smoke test

### Request (POST /readings)

```http
POST /readings
Authorization: Bearer <token>
Content-Type: application/json
```

```json
{
  "device_id": "ESP32-LAB-A01",
  "metric": "temperature",
  "value": 31.5,
  "unit": "celsius",
  "timestamp": "2026-05-13T08:30:00+07:00"
}
```

### Expected response (201 Created)

```json
{
  "reading_id": "R-20260513-0001",
  "device_id": "ESP32-LAB-A01",
  "metric": "temperature",
  "accepted": true,
  "created_at": "2026-05-13T08:30:01+07:00"
}
```

### GET /readings/latest Request

```http
GET /readings/latest?device_id=ESP32-LAB-A01&limit=5
Authorization: Bearer <token>
```

### Expected response (200 OK)

```json
{
  "items": [
    {
      "reading_id": "R-20260513-0001",
      "device_id": "ESP32-LAB-A01",
      "metric": "temperature",
      "value": 31.5,
      "unit": "celsius",
      "timestamp": "2026-05-13T08:30:00+07:00"
    }
  ]
}
```

## Error cases

### Thiếu token (401)
```json
{
  "type": "https://smart-campus.local/problems/unauthorized",
  "title": "Unauthorized",
  "status": 401,
  "detail": "Missing or invalid bearer token",
  "instance": "/readings"
}
```

### Missing device_id (400)
```json
{
  "type": "https://smart-campus.local/problems/validation-error",
  "title": "Validation error",
  "status": 400,
  "detail": "device_id is required",
  "instance": "/readings"
}
```

### Value out of range (400)
```json
{
  "type": "https://smart-campus.local/problems/value-out-of-range",
  "title": "Value out of range",
  "status": 400,
  "detail": "temperature must be between -40 and 80",
  "instance": "/readings"
}
```

## Integration notes

- Consumer (Notification) dùng mock này để test trước khi IoT team hoàn thành code thật
- Postman environment: FIT4110_lab03_mock.postman_environment.json (mock) và FIT4110_lab03_local.postman_environment.json (local)
- Mock server start: `npm run mock:iot`
- Test run: `npm run test:mock`
- Newman report: reports/newman-report-mock.xml hoặc reports/newman-report.html

## Test coverage

- ✅ Health check (GET /health)
- ✅ Happy path (POST /readings with valid data)
- ✅ Get latest readings (GET /readings/latest)
- ✅ Auth tests (missing token, invalid token)
- ✅ Negative tests (missing fields, invalid enum, wrong types)
- ✅ Boundary tests (min/max values, pagination limits)
- ✅ Response time validation (< 2000ms)

```

## Kết quả

- [x] Consumer gọi mock thành công.
- [x] Consumer parse được field cần dùng (reading_id, accepted).
- [x] Consumer hiểu lỗi 4xx/5xx provider trả về (ProblemDetails có detail/status).
- [x] Có Newman report hoặc screenshot. (reports/newman-report-mock.xml)


## Ghi chú thay đổi hợp đồng

| Nội dung | Trước | Sau | Người đồng ý |
|---|---|---|---|
| | | | |

## Xác nhận

- Provider representative:
- Consumer representative:
