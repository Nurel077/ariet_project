import mongoose from "mongoose";

export const connectDB = async (mongoUrl) => {
  try {
    const url = mongoUrl || process.env.MONGO_URL;
    
    if (!url) {
      throw new Error("MONGO_URL environment variable is not set");
    }

    const connection = await mongoose.connect(url, {
      retryWrites: true,
      w: "majority",
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    });

    console.log("✅ MongoDB Connected Successfully");
    return connection;
  } catch (error) {
    console.error("❌ MongoDB Connection Error:", error.message);
    // Retry connection after 5 seconds
    setTimeout(() => {
      console.log("🔄 Retrying MongoDB connection...");
      connectDB(mongoUrl);
    }, 5000);
  }
};