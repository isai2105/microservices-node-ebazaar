import express from 'express';
import cors from 'cors';
import router from './routes';

const app = express();
app.use(cors());
app.use(express.json());
app.use('/', router);

const port = process.env.PORT || 3002;
app.listen(port, () => console.log(`product-service listening on ${port}`));
