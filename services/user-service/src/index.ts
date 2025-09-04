import express from 'express';
import cors from 'cors';
import router from './routes';

const app = express();
app.use(cors());
app.use(express.json());
app.use('/users', router);

const port = process.env.PORT || 3001;
app.listen(port, () => console.log(`user-service listening on ${port}`));
