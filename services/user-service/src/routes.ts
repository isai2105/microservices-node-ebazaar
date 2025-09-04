import { Router } from 'express';
import { prisma } from './db';
import bcrypt from 'bcryptjs';
import { signToken, verifyToken } from '@ebazaar/common/dist/auth';

const router = Router();

router.post('/register', async (req, res) => {
    const { email, password, name } = req.body;
    const hash = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({ data: { email, password: hash, name } });
    res.json({ id: user.id, email: user.email, name: user.name });
});

router.post('/login', async (req, res) => {
    const { email, password } = req.body;
    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) return res.status(401).json({ error: 'Invalid credentials' });
    const valid = await bcrypt.compare(password, user.password);
    if (!valid) return res.status(401).json({ error: 'Invalid credentials' });
    const token = signToken({ userId: user.id });
    res.json({ token });
});

router.get('/me', async (req, res) => {
    const auth = req.headers.authorization?.split(' ')[1];
    if (!auth) return res.status(401).json({ error: 'No token' });
    try {
        const { userId } = verifyToken(auth);
        const user = await prisma.user.findUnique({ where: { id: userId }, select: { id: true, email: true, name: true } });
        if (!user) return res.status(404).json({ error: 'Not found' });
        res.json(user);
    } catch {
        res.status(401).json({ error: 'Invalid token' });
    }
});

export default router;