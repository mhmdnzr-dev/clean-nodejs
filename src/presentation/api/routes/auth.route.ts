import { Hono } from 'hono'
import { AuthService } from '../../../core/application-service/authService.js'


const authRoutes = new Hono()
const service = new AuthService()

authRoutes.post('/register', async c => {
  const data = await c.req.json()
  const result = await service.register(data)
  return c.json(result)
})

authRoutes.post('/login', async c => {
  const data = await c.req.json()
  const result = await service.login(data)
  return c.json(result)
})

export default authRoutes
