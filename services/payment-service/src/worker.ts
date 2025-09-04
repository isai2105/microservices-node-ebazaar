import { kafka, TOPICS } from '@ebazaar/common/dist/kafka';


export async function startPaymentWorker() {
    const consumer = kafka.consumer({ groupId: 'payment-service-consumer' });
    const producer = kafka.producer();
    await consumer.connect();
    await producer.connect();
    await consumer.subscribe({ topic: TOPICS.ORDER_CREATED, fromBeginning: true });


    await consumer.run({
        eachMessage: async ({ message }) => {
            const payload = JSON.parse(message.value?.toString() || '{}');
            const { orderId, totalCents } = payload;
            // Simulate payment logic
            const approved = Math.random() > 0.1; // 90% success
            const outTopic = approved ? TOPICS.PAYMENT_SUCCESS : TOPICS.PAYMENT_FAILED;
            await new Promise(r => setTimeout(r, 500));
            await producer.send({ topic: outTopic, messages: [{ value: JSON.stringify({ orderId, totalCents }) }] });
            console.log(`[payment-service] Processed ${orderId} -> ${outTopic}`);
        }
    });
}