import { Kafka, logLevel } from 'kafkajs';
import { env } from './env';

export const kafka = new Kafka({
  clientId: env.kafkaClientId,
  brokers: env.kafkaBrokers,
  logLevel: logLevel.ERROR,
});

export const TOPICS = {
  ORDER_CREATED: 'order_created',
  PAYMENT_SUCCESS: 'payment_success',
  PAYMENT_FAILED: 'payment_failed',
} as const;
