import dotenv from 'dotenv';
import app from './app';

dotenv.config();

const port = Number(process.env.PORT) || 3002;

app.listen(port, () => {
  console.log(`Expert service listening on port ${port}`);
});
