import dotenv from 'dotenv';
import app from './app';

dotenv.config();

const port = Number(process.env.PORT) || 3003;

app.listen(port, () => {
  console.log(`Product service listening on port ${port}`);
});
