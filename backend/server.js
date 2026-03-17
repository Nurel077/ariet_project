import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import "dotenv/config";
import { connectDB } from "./config/db.js";

import foodRouter from "./routes/foodRoute.js";
import userRouter from "./routes/userRoute.js";
import cartRouter from "./routes/cartRoute.js";
import orderRouter from "./routes/orderRoute.js";

// config env
dotenv.config();

// app config
const app = express();
const port = process.env.PORT || 4000;

// middlewares
app.use(express.json());
app.use(cors());

// database connection
connectDB(process.env.MONGO_URI);

// API routes
app.use("/api/food", foodRouter);
app.use("/api/user", userRouter);
app.use("/api/cart", cartRouter);
app.use("/api/order", orderRouter);

// static images
app.use("/images", express.static("uploads"));

// test route
app.get("/", (req, res) => {
  res.send("API Working");
});

// server start
app.listen(port, () => {
  console.log(`🚀 Server Started on port: ${port}`);
});