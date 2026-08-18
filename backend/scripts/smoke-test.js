#!/usr/bin/env node

const baseUrl = process.argv[2] || 'http://localhost:5000';
const email = process.argv[3] || 'doctor@clinic.com';
const password = process.argv[4] || 'password123';

async function request(path, options = {}) {
  const { headers: extraHeaders = {}, ...fetchOptions } = options;

  const requestHeaders = {
    'Content-Type': 'application/json',
    ...extraHeaders,
  };

  const response = await fetch(`${baseUrl}${path}`, {
    ...fetchOptions,
    headers: requestHeaders,
  });

  const payload = await response.json().catch(() => ({}));

  return {
    ok: response.ok,
    status: response.status,
    payload,
  };
}

async function main() {
  console.log('== Smoke Test ==');
  console.log('Base URL:', baseUrl);

  const health = await request('/api/health');
  console.log('1) Health check:', health.ok ? 'PASS' : 'FAIL', health.payload);

  const login = await request('/api/auth/doctor/login', {
    method: 'POST',
    body: JSON.stringify({ email, password }),
  });

  if (!login.ok || !login.payload?.data?.token) {
    console.log('2) Doctor login:', 'FAIL', login.payload);
    process.exit(1);
  }

  console.log('2) Doctor login:', 'PASS');

  const token = login.payload.data.token;

  const myQueue = await request('/api/doctors/me/queue', {
    headers: { Authorization: `Bearer ${token}` },
  });

  console.log('3) Fetch queue:', myQueue.ok ? 'PASS' : 'FAIL', myQueue.payload);

  const newBooking = await request('/api/tokens', {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}` },
    body: JSON.stringify({
      doctorId: 1,
      patient: {
        name: 'Smoke Test Patient',
        phone: '9999999900',
        age: 30,
        gender: 'Male',
      },
    }),
  });

  console.log('4) Create token:', newBooking.ok ? 'PASS' : 'FAIL', newBooking.payload);

  const nextStep = await request('/api/doctors/me/queue/next', {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}` },
  });

  console.log('5) Advance queue:', nextStep.ok ? 'PASS' : 'FAIL', nextStep.payload);

  const status = await request('/api/doctors/me/status', {
    headers: { Authorization: `Bearer ${token}` },
  });

  console.log('6) Doctor status:', status.ok ? 'PASS' : 'FAIL', status.payload);

  console.log('Smoke test completed.');
}

main().catch((error) => {
  console.error('Smoke test crashed:', error);
  process.exit(1);
});
