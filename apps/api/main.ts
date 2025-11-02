// apps/api/main.ts
import { Hono } from 'hono';
import { serve } from '@hono/node-server';

const app = new Hono();

app.get('/', (c) => c.text('Hono + 1M RPS = 🚀'));

serve({
  fetch: app.fetch,
  port: 3000
});

console.log('Worker running on 3000');