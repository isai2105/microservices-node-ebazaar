import express from 'express';
import { startPaymentWorker } from './worker';

const app = express();
app.get('/', (_req, res) => res.send('payment-service ok'));

const port = process.env.PORT || 3004;
app.listen(port, async () => {
  console.log(`payment-service listening on ${port}`);
  startPaymentWorker().catch(console.error);
});
