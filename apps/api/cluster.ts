// apps/api/cluster.ts
import cluster from 'node:cluster';
import os from 'node:os';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);

const rawWorkers = process.env['NODE_CLUSTER_WORKERS'];
const numCPUs = (typeof rawWorkers === 'string' ? parseInt(rawWorkers, 10) : rawWorkers) || os.cpus().length;

if (cluster.isPrimary) {
  console.log(`Primary ${process.pid} is running`);

  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('exit', (worker) => {
    console.log(`Worker ${worker.process.pid} died`);
    cluster.fork();
  });
} else {
  import('./main.js');
}