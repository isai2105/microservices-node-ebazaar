import { Router } from 'express';
import { prisma } from './db';
import axios from 'axios';
import { kafka, TOPICS } from '@ebazaar/common/dist/kafka';

const router = Router();

router.get('/orders', async (_req, res) => {
const orders = await prisma.order.findMany();
res.json(orders);
});

router.post('/orders', async (req, res) => {
const { userId, items } = req.body as { userId: string; items: { productId: string; qty: number; priceCents: number }[] };
const totalCents = items.reduce((sum, i) => sum + i.qty * i.priceCents, 0);
const order = await prisma.order.create({ data: { userId, totalCents } });

// Emit ORDER_CREATED
const producer = kafka.producer();
await producer.connect();
await producer.send({
topic: TOPICS.ORDER_CREATED,
messages: [{ value: JSON.stringify({ orderId: order.id, userId, totalCents }) }]
});
await producer.disconnect();

res.status(201).json(order);
});

export default router;