import bcrypt from 'bcrypt'
import { z } from 'zod'
import { pool } from '../../infra/postgres/index.js'
import { Jwt } from '../../infra/security/jwt.js'

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
})

export class AuthService {
  async register(data: unknown) {
    const { email, password } = schema.parse(data)
    const hash = await bcrypt.hash(password, 10)
    const result = await pool.query(
      'INSERT INTO users (email, password_hash, role) VALUES ($1, $2, $3) RETURNING id, email, role',
      [email, hash, 'User']
    )
    const user = result.rows[0]
    const token = await Jwt.sign({ id: user.id, role: user.role })
    return { user, token }
  }

  async login(data: unknown) {
    const { email, password } = schema.parse(data)
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email])
    const user = result.rows[0]
    if (!user) throw new Error('Invalid credentials')

    const valid = await bcrypt.compare(password, user.password_hash)
    if (!valid) throw new Error('Invalid credentials')

    const token = await Jwt.sign({ id: user.id, role: user.role })
    return { user, token }
  }
}
