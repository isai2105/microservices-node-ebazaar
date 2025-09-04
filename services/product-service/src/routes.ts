import { Router } from 'express';
import { prisma } from './db';

const router = Router();

router.get('/products', async (_req, res) => {
  const items = await prisma.product.findMany();
  res.json(items);
});

router.post('/products', async (req, res) => {
  const { name, description, priceCents, stock } = req.body;
  const p = await prisma.product.create({
    data: { name, description, priceCents, stock },
  });
  res.status(201).json(p);
});

router.get('/products/:id', async (req, res) => {
  const p = await prisma.product.findUnique({ where: { id: req.params.id } });
  if (!p) return res.status(404).json({ error: 'Not found' });
  res.json(p);
});

router.put('/products/:id', async (req, res) => {
  const p = await prisma.product.update({
    where: { id: req.params.id },
    data: req.body,
  });
  res.json(p);
});

router.delete('/products/:id', async (req, res) => {
  await prisma.product.delete({ where: { id: req.params.id } });
  res.status(204).end();
});

export default router;
