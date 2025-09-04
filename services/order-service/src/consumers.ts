import { kafka, TOPICS } from '@ebazaar/common/dist/kafka';
import { prisma } from './db';

export async function startConsumers() {
  const consumer = kafka.consumer({ groupId: 'order-service-consumer' });
  await consumer.connect();
  await consumer.subscribe({
    topic: TOPICS.PAYMENT_SUCCESS,
    fromBeginning: true,
  });
  await consumer.subscribe({
    topic: TOPICS.PAYMENT_FAILED,
    fromBeginning: true,
  });

  await consumer.run({
    eachMessage: async ({ topic, message }) => {
      const payload = JSON.parse(message.value?.toString() || '{}');
      const orderId = payload.orderId as string;
      if (!orderId) return;
      if (topic === TOPICS.PAYMENT_SUCCESS) {
        await prisma.order.update({
          where: { id: orderId },
          data: { status: 'PAID' },
        });
      } else if (topic === TOPICS.PAYMENT_FAILED) {
        await prisma.order.update({
          where: { id: orderId },
          data: { status: 'FAILED' },
        });
      }
      console.log(`[order-service] Updated order ${orderId} due to ${topic}`);
    },
  });
}
