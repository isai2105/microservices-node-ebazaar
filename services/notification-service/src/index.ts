import express from 'express';
import { startNotificationWorker } from './worker';

const app = express();
app.get('/', (_req, res) => res.send('notification-service ok'));

const port = process.env.PORT || 3005;
app.listen(port, async () => {
  console.log(`notification-service listening on ${port}`);
  startNotificationWorker().catch(console.error);
});
