import { Context } from 'hono'

export const authorize =
  (roles: string[]) =>
  async (c: Context, next: () => Promise<void>) => {
    const user = c.get('user') as { role?: string }
    if (!user || !roles.includes(user.role || ''))
      return c.json({ error: 'Forbidden' }, 403)
    await next()
  }
