import { serve } from '@hono/node-server'
import app from '../../src/presentation/api/server.js'

serve(app)
