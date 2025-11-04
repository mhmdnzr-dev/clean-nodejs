import { Hono } from "hono";
import { authMiddleware } from "./middlewares/authMiddleware.js";
import authRoutes from "./routes/auth.route.js";
import { authorize } from "./middlewares/authorize.js";

const app = new Hono();

app.route("/auth", authRoutes);

app.get("/secure", authMiddleware, authorize(["Admin"]), (c) =>
  c.json({ message: "Welcome Admin" })
);

export default app;
