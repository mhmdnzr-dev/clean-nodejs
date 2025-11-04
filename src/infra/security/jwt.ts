import { SignJWT, jwtVerify } from 'jose'

const secret = new TextEncoder().encode(process.env.JWT_SECRET || 'dev-secret')

export const Jwt = {
  async sign(payload: object, expiresIn = '1h') {
    return await new SignJWT(payload)
      .setProtectedHeader({ alg: 'HS256' })
      .setExpirationTime(expiresIn)
      .sign(secret)
  },

  async verify(token: string) {
    const { payload } = await jwtVerify(token, secret)
    return payload
  },
}
