import express from 'express';
import cors from 'cors';
import router from './routes';
import { startConsumers } from './consumers';

const app = express();
app.use(cors());
app.use(express.json());
app.use('/', router);

const port = process.env.PORT || 3003;
app.listen(port, async () => {
  console.log(`order-service listening on ${port}`);
  startConsumers().catch((err) => console.error('consumer error', err));
});
