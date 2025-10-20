import mongoose, { ConnectOptions } from 'mongoose';

export const connectDB = async (): Promise<void> => {
  const uri =
    process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/healzone-experts';
  const options: ConnectOptions = {
    maxPoolSize: Number(process.env.MONGODB_MAX_POOL_SIZE || 10)
  };

  if (process.env.MONGODB_DEBUG === 'true') {
    mongoose.set('debug', true);
  }

  try {
    await mongoose.connect(uri, options);
    mongoose.set('strictQuery', false);
    console.log('Connected to MongoDB for expert-service');
  } catch (error) {
    console.error('MongoDB connection error in expert-service', error);
    process.exit(1);
  }
};

export const disconnectDB = async (): Promise<void> => {
  await mongoose.connection.close();
};
