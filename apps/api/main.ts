// apps/api/main.ts
import { Hono } from 'hono'
import { serve } from '@hono/node-server'

const app = new Hono()

app.get('/', (c) => c.text('Hono + DDD = 🔥'))

serve({
  fetch: app.fetch,
  port: 3000
})

console.log('Server running on http://localhost:3000')