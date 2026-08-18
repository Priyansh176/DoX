# Waitless

Patient token booking client for the clinic backend.

The app reads clinics from `GET /api/clinics`, books with `POST /api/tokens`, refreshes its token through `GET /api/tokens/:tokenId`, and joins the selected doctor's Socket.IO room for `queue-updated` events. Booking sends only `doctorId` and `patient.name`, `patient.phone`, `patient.age`, and `patient.gender`.

The default Android-emulator backend URL is `http://10.0.2.2:5000`. Override it for a device or another environment with `--dart-define=API_URL=http://<host>:5000`.

`GET /api/clinics` must include each clinic's displayable `doctors` array (with `id`, `name`, `specialization`, and `status`) for doctor selection. The current checked-in backend route returns only clinic fields, so it cannot populate a real doctor picker without that existing API response being expanded.
