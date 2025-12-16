# Setup Vite for frontend build
say "Setting up Vite...", :green

# Add vite_rails gem
gem "vite_rails", comment: "Use Vite for frontend build" unless gem_exists?("vite_rails")

# Create package.json (force overwrite in non-interactive mode)
create_file "package.json", <<~JSON, force: ENV["RAILS_TEMPLATE_NON_INTERACTIVE"] == "true"
  {
    "name": "app",
    "private": true,
    "type": "module",
    "scripts": {
      "dev": "vite",
      "build": "vite build",
      "preview": "vite preview"
    },
    "dependencies": {
      "@inertiajs/core": "^1.0.0",
      "@vitejs/plugin-react": "^4.2.0",
      "autoprefixer": "^10.4.16",
      "postcss": "^8.4.32",
      "tailwindcss": "^3.3.6",
      "vite": "^5.0.8"
    },
    "devDependencies": {
      "@types/node": "^20.10.5",
      "typescript": "^5.3.3"
    }
  }
JSON

# Copy vite.config.ts
copy_file "files/config/vite.config.ts", "vite.config.ts", force: ENV["RAILS_TEMPLATE_NON_INTERACTIVE"] == "true"

# Create tsconfig.json
create_file "tsconfig.json", <<~JSON, force: ENV["RAILS_TEMPLATE_NON_INTERACTIVE"] == "true"
  {
    "compilerOptions": {
      "target": "ES2020",
      "useDefineForClassFields": true,
      "module": "ESNext",
      "lib": ["ES2020", "DOM", "DOM.Iterable"],
      "skipLibCheck": true,
      "moduleResolution": "bundler",
      "allowImportingTsExtensions": true,
      "resolveJsonModule": true,
      "isolatedModules": true,
      "noEmit": true,
      "strict": true,
      "noUnusedLocals": true,
      "noUnusedParameters": true,
      "noFallthroughCasesInSwitch": true,
      "paths": {
        "@/*": ["./app/frontend/*"]
      }
    },
    "include": ["app/frontend"]
  }
JSON

# Create tsconfig.node.json
create_file "tsconfig.node.json", <<~JSON, force: ENV["RAILS_TEMPLATE_NON_INTERACTIVE"] == "true"
  {
    "compilerOptions": {
      "composite": true,
      "skipLibCheck": true,
      "module": "ESNext",
      "moduleResolution": "bundler",
      "allowSyntheticDefaultImports": true
    },
    "include": ["vite.config.ts"]
  }
JSON

# Create app/frontend directory structure
run "mkdir -p app/frontend/entrypoints"

say "✓ Vite configured", :green
