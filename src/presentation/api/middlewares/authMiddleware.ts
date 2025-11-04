import { Jwt } from "../../../infra/security/jwt.js";

export const authMiddleware = async (c: any, next: () => Promise<void>) => {
  const header = c.req.header("authorization");
  if (!header?.startsWith("Bearer "))
    return c.json({ error: "Unauthorized" }, 401);

  const token = header.substring(7);
  try {
    const payload = await Jwt.verify(token);
    c.set("user", payload);
    await next();
  } catch {
    return c.json({ error: "Invalid token" }, 401);
  }
};
