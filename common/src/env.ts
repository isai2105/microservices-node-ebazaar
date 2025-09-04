import dotenv from 'dotenv';
dotenv.config();


export const env = {
    kafkaBrokers: (process.env.KAFKA_BROKERS || 'localhost:9092').split(','),
    kafkaClientId: process.env.KAFKA_CLIENT_ID || 'microservices-demo',
    jwtSecret: process.env.JWT_SECRET || 'devsecret'
};