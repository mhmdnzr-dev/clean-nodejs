import { betterAuth } from 'better-auth'
import { Pool } from 'pg'

const pool = new Pool({ connectionString: process.env.DATABASE_URL })

export const auth = betterAuth({
  database: pool,
  emailAndPassword: { enabled: true },
  session: { strategy: 'jwt' },
  jwt: { secret: process.env.JWT_SECRET! },
  trustedOrigins: [process.env.FRONTEND_URL!]
})
