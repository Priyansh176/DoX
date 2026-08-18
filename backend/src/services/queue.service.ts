import { DoctorStatus, Token, TokenStatus } from '../types';
import { getTodayDateString, tokens } from '../data/store';

export interface QueueSnapshot {
  doctorId: number;
  currentToken: number | null;
  waitingCount: number;
  queue: Array<{ tokenNumber: number; patientName: string; status: TokenStatus; tokenId: number; bookedAt: Date }>;
}

export function getQueueSnapshotForDoctor(doctorId: number): QueueSnapshot {
  const today = getTodayDateString();
  const queue = tokens
    .filter((token) => token.doctor_id === doctorId && token.booking_date === today)
    .sort((a, b) => a.token_number - b.token_number);

  const currentToken = queue.find((item) => item.status === 'SERVING') ?? null;
  const waitingTokens = queue.filter((item) => item.status === 'WAITING');

  return {
    doctorId,
    currentToken: currentToken ? currentToken.token_number : null,
    waitingCount: waitingTokens.length,
    queue: queue.map((item) => ({
      tokenNumber: item.token_number,
      patientName: `Patient ${item.patient_id}`,
      status: item.status,
      tokenId: item.id,
      bookedAt: item.booked_at,
    })),
  };
}

export function advanceQueueForDoctor(doctorId: number) {
  const today = getTodayDateString();
  const queue = tokens
    .filter((token) => token.doctor_id === doctorId && token.booking_date === today)
    .sort((a, b) => a.token_number - b.token_number);

  const servingToken = queue.find((item) => item.status === 'SERVING');

  if (servingToken) {
    servingToken.status = 'COMPLETED';
    servingToken.completed_at = new Date();
  }

  const nextWaiting = queue.find((item) => item.status === 'WAITING');

  if (nextWaiting) {
    nextWaiting.status = 'SERVING';
    nextWaiting.started_at = new Date();
  }

  return {
    completedToken: servingToken ? servingToken.token_number : null,
    currentToken: nextWaiting ? nextWaiting.token_number : null,
    message: nextWaiting ? 'Queue advanced' : 'No waiting patients',
  };
}

export function calculatePatientsAhead(tokenNumber: number, doctorId: number) {
  const today = getTodayDateString();
  const queue = tokens
    .filter((token) => token.doctor_id === doctorId && token.booking_date === today)
    .sort((a, b) => a.token_number - b.token_number);

  const current = queue.find((item) => item.token_number === tokenNumber);

  if (!current) {
    return 0;
  }

  const waitingBefore = queue.filter(
    (item) => item.status === 'WAITING' && item.token_number < current.token_number,
  ).length;

  const servingBefore = queue.some(
    (item) => item.status === 'SERVING' && item.token_number < current.token_number,
  )
    ? 1
    : 0;

  return waitingBefore + servingBefore;
}

export function calculateEstimatedWaitMinutes(doctorId: number, tokenNumber: number) {
  const patientsAhead = calculatePatientsAhead(tokenNumber, doctorId);
  return patientsAhead * 5;
}

export function isDoctorAvailable(status: DoctorStatus) {
  return status === 'ACTIVE';
}
