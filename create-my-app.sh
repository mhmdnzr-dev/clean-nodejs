#!/bin/bash

# my-app DDD + Clean Arch (Node.js/TS) – SINGLE package.json & tsconfig
# Run: chmod +x create-my-app.sh && ./create-my-app.sh

set -e

echo "Creating my-app (single root package.json + tsconfig) with DDD + Clean Architecture..."

mkdir -p my-app
cd my-app

# Root config files
touch package.json
touch tsconfig.json
touch pnpm-workspace.yaml
touch docker-compose.yaml
touch Dockerfile
touch nginx.conf
touch .env.example
touch .gitignore

# src/core
mkdir -p src/core/application-service/{exceptions,features,use-cases}
touch src/core/application-service/index.ts

mkdir -p src/core/contract/{configs,dtos,events}
touch src/core/contract/index.ts

mkdir -p src/core/domain/{entities,value-objects,exceptions,repositories}
touch src/core/domain/index.ts

mkdir -p src/core/domain-service/{interfaces,services}
touch src/core/domain-service/index.ts

# src/infra
mkdir -p src/infra/file/services
touch src/infra/file/index.ts

mkdir -p src/infra/identity/services
touch src/infra/identity/index.ts

mkdir -p src/infra/mongo/{models,repositories}
touch src/infra/mongo/index.ts

mkdir -p src/infra/rabbitmq/{publishers,consumers}
touch src/infra/rabbitmq/index.ts

mkdir -p src/infra/redis/cache
touch src/infra/redis/index.ts

mkdir -p src/infra/sql/{entities,repositories,migrations}
touch src/infra/sql/index.ts

# src/presentation
mkdir -p src/presentation/api/{controllers,routes,middlewares}
touch src/presentation/api/server.ts

mkdir -p src/presentation/web
touch src/presentation/web/app.ts
touch src/presentation/web/server.ts

# src/orchestration
mkdir -p src/orchestration/app-host
touch src/orchestration/app-host/bootstrap.ts
touch src/orchestration/app-host/container.ts

# apps
mkdir -p apps/api
touch apps/api/main.ts

mkdir -p apps/web
touch apps/web/main.ts

# tests
mkdir -p tests/unit/core
mkdir -p tests/unit/infra
mkdir -p tests/unit/presentation
mkdir -p tests/integration/api
mkdir -p tests/integration/database
mkdir -p tests/e2e/api

# scripts
mkdir -p scripts
touch scripts/migrate.ts
touch scripts/seed.ts

# Optional: Add basic package.json
cat > package.json << 'EOF'
{
  "name": "my-app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "ts-node-dev apps/api/main.ts",
    "build": "tsc",
    "start": "node dist/apps/api/main.js",
    "test": "jest",
    "test:watch": "jest --watch"
  },
  "devDependencies": {
    "typescript": "^5.5.0",
    "ts-node-dev": "^2.0.0",
    "@types/node": "^20.0.0",
    "jest": "^29.0.0",
    "ts-jest": "^29.0.0"
  }
}
EOF

# Optional: Add root tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./",
    "strict": true,
    "moduleResolution": "node",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "baseUrl": ".",
    "paths": {
      "@core/*": ["src/core/*"],
      "@infra/*": ["src/infra/*"],
      "@presentation/*": ["src/presentation/*"],
      "@orchestration/*": ["src/orchestration/*"]
    }
  },
  "include": ["src/**/*", "apps/**/*", "tests/**/*", "scripts/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# Optional: Add .gitignore
cat > .gitignore << 'EOF'
node_modules
dist
.env
*.log
coverage
EOF

echo "Done! Single package.json + tsconfig structure created."
echo ""
echo "Next steps:"
echo "   cd my-app"
echo "   pnpm init -y"
echo "   pnpm add -D typescript ts-node-dev @types/node jest ts-jest"
echo "   pnpm add express inversify reflect-metadata"
echo "   # Start coding in apps/api/main.ts"