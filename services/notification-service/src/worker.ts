import { kafka, TOPICS } from '@ebazaar/common/dist/kafka';


export async function startNotificationWorker() {
    const consumer = kafka.consumer({ groupId: 'notification-service-consumer' });
    await consumer.connect();
    await consumer.subscribe({ topic: TOPICS.PAYMENT_SUCCESS, fromBeginning: true });
    await consumer.run({
        eachMessage: async ({ message }) => {
            const payload = JSON.parse(message.value?.toString() || '{}');
            // In real life, send email/SMS. Here just log.
            console.log(`[notification-service] Order ${payload.orderId} paid. Sending email...`);
        }
    });
}