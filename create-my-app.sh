#!/bin/bash

set -e

read -p "Enter application name: " APP_NAME
read -p "Do you want to use TypeScript (ts) or JavaScript (js)? " LANG

if [[ "$LANG" != "ts" && "$LANG" != "js" ]]; then
  echo "Invalid choice. Please enter 'ts' or 'js'."
  exit 1
fi

echo "Creating $APP_NAME (Hono + DDD + Clean Arch, $LANG version)..."

mkdir -p "$APP_NAME"
cd "$APP_NAME"

# Root files
touch package.json
touch docker-compose.yaml
touch Dockerfile
touch nginx.conf
touch .env.example
touch .gitignore

if [[ "$LANG" == "ts" ]]; then
  touch tsconfig.json
fi

# src/core
mkdir -p src/core/application-service/{exceptions,features,use-cases}
touch src/core/application-service/index.$LANG

mkdir -p src/core/contract/{configs,dtos,events}
touch src/core/contract/index.$LANG

mkdir -p src/core/domain/{entities,value-objects,exceptions,repositories}
touch src/core/domain/index.$LANG

mkdir -p src/core/domain-service/{interfaces,services}
touch src/core/domain-service/index.$LANG

# src/infra
mkdir -p src/infra/file/services
touch src/infra/file/index.$LANG

mkdir -p src/infra/identity/services
touch src/infra/identity/index.$LANG

mkdir -p src/infra/mongo/{models,repositories}
touch src/infra/mongo/index.$LANG

mkdir -p src/infra/rabbitmq/{publishers,consumers}
touch src/infra/rabbitmq/index.$LANG

mkdir -p src/infra/redis/cache
touch src/infra/redis/index.$LANG

mkdir -p src/infra/sql/{entities,repositories,migrations}
touch src/infra/sql/index.$LANG

# src/presentation (Hono API)
mkdir -p src/presentation/api/{controllers,routes,middlewares}
touch src/presentation/api/server.$LANG

# apps/api (Hono entry)
mkdir -p apps/api
touch apps/api/main.$LANG

# tests
mkdir -p tests/unit/core
mkdir -p tests/unit/infra
mkdir -p tests/unit/presentation
mkdir -p tests/integration/api
mkdir -p tests/e2e/api

# scripts
mkdir -p scripts
touch scripts/migrate.$LANG
touch scripts/seed.$LANG

# package.json
if [[ "$LANG" == "ts" ]]; then
  cat > package.json << 'JSON'
{
  "name": "APP_NAME",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "tsx watch apps/api/main.ts",
    "build": "tsc",
    "start": "node dist/apps/api/main.js"
  },
  "devDependencies": {
    "typescript": "^5.5.0",
    "tsx": "^4.7.0",
    "@types/node": "^20.0.0"
  },
  "dependencies": {
    "hono": "^4.6.0",
    "@hono/node-server": "^1.12.0"
  }
}
JSON

  # tsconfig.json
  cat > tsconfig.json << 'JSON'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "baseUrl": ".",
    "paths": {
      "@core/*": ["src/core/*"],
      "@infra/*": ["src/infra/*"],
      "@presentation/*": ["src/presentation/*"]
    }
  },
  "include": ["src/**/*", "apps/**/*", "tests/**/*", "scripts/**/*"],
  "exclude": ["node_modules", "dist"]
}
JSON

else
  cat > package.json << 'JSON'
{
  "name": "APP_NAME",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "node apps/api/main.js",
    "start": "node apps/api/main.js"
  },
  "dependencies": {
    "hono": "^4.6.0",
    "@hono/node-server": "^1.12.0"
  }
}
JSON
fi

# Replace placeholder with actual app name
sed -i.bak "s/APP_NAME/$APP_NAME/g" package.json && rm package.json.bak

# .gitignore
cat > .gitignore << 'EOF'
node_modules
dist
.env
*.log
coverage
EOF

echo ""
echo "$APP_NAME created successfully!"
echo ""
echo "Next steps:"
echo "  cd $APP_NAME"
echo "  npm install"
echo "  npm run dev"
