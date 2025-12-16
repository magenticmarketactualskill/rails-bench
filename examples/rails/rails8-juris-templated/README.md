# Rails 8 + Juris.js Demo App - ActiveDataFlow Example

This is a demonstration Rails 8 application showcasing ActiveDataFlow functionality using **Juris.js** instead of React. The app demonstrates the same product catalog synchronization use case with data transformation as the React version, but implemented with a different frontend framework.

## Overview

This demo app illustrates how to integrate ActiveDataFlow into a Rails application using Juris.js to:
- Read data from a source table (products)
- Transform the data (price conversion, slug generation)
- Write to a destination table (product_exports)
- Monitor DataFlow execution through a web interface

## Key Differences from React Version

### Frontend Framework
- **React Version**: Uses React with TypeScript and JSX
- **Juris.js Version**: Uses vanilla JavaScript with a custom component system
- **Similarities**: Both use Inertia.js for Rails integration and TailwindCSS for styling

### Component Patterns

#### React Components
```tsx
export default function ProductsIndex({ products }: { products: Product[] }) {
    return (
        <MainLayout>
            <Table>
                {products.map((product) => (
                    <TableRow key={product.id}>
                        <TableCell>{product.name}</TableCell>
                    </TableRow>
                ))}
            </Table>
        </MainLayout>
    )
}
```

#### Juris.js Components
```javascript
export default function ProductsIndex({ products = [] }) {
  return MainLayout({
    children: html`
      ${Table({
        children: products.map(product => 
          TableRow({
            children: html`${TableCell({ children: product.name })}`
          })
        ).join('')
      })}
    `
  })
}
```

### Build System
- **React Version**: Vite with React plugin and TypeScript
- **Juris.js Version**: Vite with vanilla JavaScript and custom Juris.js framework

## Requirements

- Ruby 2.7 or higher
- Rails 8.1+
- SQLite3
- Node.js 18+ (for frontend build)

## Setup Instructions

### 1. Clone the Repository

If you're cloning the parent repository with submodules:

```bash
git clone --recursive https://github.com/yourusername/active_data_flow.git
cd active_data_flow/submodules/examples/rails8-juris
```

Or if you already have the repository:

```bash
cd active_data_flow/submodules/examples/rails8-juris
```

### 2. Install Dependencies

Install Ruby dependencies:
```bash
bundle install
```

Install JavaScript dependencies:
```bash
npm install
```

### 3. Setup Database

Create the database, run migrations, and load seed data:

```bash
rails db:create
rails db:migrate
rails db:seed
```

This will create:
- 15 sample products (12 active, 3 inactive)
- Database tables for products and product_exports

### 4. Build Frontend Assets

Build the Juris.js frontend:
```bash
npm run build
```

For development with hot reloading:
```bash
npm run dev
```

### 5. Start the Server

```bash
rails server
```

The application will be available at `http://localhost:3000`

## Application Structure

### Backend (Identical to React Version)

- **Product**: Source table containing product catalog data
  - Fields: name, sku, price, category, active
  
- **ProductExport**: Destination table for transformed product data
  - Fields: product_id, name, sku, price_cents, category_slug, exported_at

- **ProductSyncFlow**: Demonstrates data transformation
  - Filters active products only
  - Converts price to cents (multiply by 100)
  - Generates category slugs using parameterize
  - Adds export timestamp

### Frontend (Juris.js Implementation)

```
app/frontend/
├── entrypoints/
│   ├── application.js          # Main Juris.js + Inertia entry point
│   └── application.css         # TailwindCSS styles
├── pages/
│   ├── Home/Index.js          # Home page component
│   ├── Products/
│   │   ├── Index.js           # Products listing
│   │   └── Show.js            # Product detail
│   ├── ProductExports/
│   │   └── Index.js           # Product exports listing
│   └── DataFlows/
│       └── Index.js           # DataFlow management
├── components/
│   └── ui/
│       ├── table.js           # Table components
│       ├── button.js          # Button component
│       ├── badge.js           # Badge component
│       └── card.js            # Card components
├── layouts/
│   └── MainLayout.js          # Main application layout
└── lib/
    ├── juris.js               # Custom Juris.js framework
    └── utils.js               # Utility functions
```

## Juris.js Framework

This demo includes a minimal Juris.js-like framework implementation for demonstration purposes:

### Component Definition
```javascript
import { html } from '@/lib/juris'

export function Button({ children, variant = 'default', onClick }) {
  return html`
    <button class="px-4 py-2 rounded ${variant}" onclick="${onClick}">
      ${children}
    </button>
  `
}
```

### Template Literals
```javascript
import { html } from '@/lib/juris'

const template = html`
  <div class="container">
    <h1>${title}</h1>
    ${items.map(item => html`<p>${item}</p>`).join('')}
  </div>
`
```

### State Management
```javascript
import { useState } from '@/lib/juris'

const [count, setCount] = useState(0)
```

## Usage

### View Products

Visit `http://localhost:3000` to see the list of products in the catalog.

### View Exports

Visit `http://localhost:3000/product_exports` to see products that have been exported.

### Trigger DataFlow

Trigger the DataFlow processing:

```bash
curl -X POST http://localhost:3000/active_data_flow/data_flows/heartbeat
```

Or visit the DataFlows dashboard at `http://localhost:3000/active_data_flow/data_flows`

## Development

### Frontend Development

Start the development server with hot reloading:
```bash
npm run dev
```

Build for production:
```bash
npm run build
```

### Adding New Components

1. Create component in `app/frontend/components/`
2. Export component function
3. Import and use in pages or other components

Example:
```javascript
// app/frontend/components/ui/alert.js
import { html } from '@/lib/juris'

export function Alert({ children, variant = 'info' }) {
  return html`
    <div class="alert alert-${variant}">
      ${children}
    </div>
  `
}
```

### Adding New Pages

1. Create page component in `app/frontend/pages/`
2. Add to pages object in `application.js`
3. Create corresponding Rails controller action

## Comparison with React Version

| Feature | React Version | Juris.js Version |
|---------|---------------|------------------|
| **Components** | JSX with TypeScript | Template literals with JavaScript |
| **State Management** | React hooks | Custom useState implementation |
| **Build System** | Vite + React plugin | Vite + custom setup |
| **Type Safety** | TypeScript | JavaScript (optional TypeScript) |
| **Bundle Size** | Larger (React runtime) | Smaller (minimal framework) |
| **Learning Curve** | React ecosystem | Simpler, vanilla JS concepts |
| **Performance** | Virtual DOM | Direct DOM manipulation |

## Integration with Inertia.js and Rails

### Rails Controller
```ruby
class ProductsController < ApplicationController
  def index
    @products = Product.order(id: :asc)
    render inertia: 'Products/Index', props: {
      products: @products.as_json(only: [:id, :sku, :name, :price, :category, :active])
    }
  end
end
```

### Juris.js Page Component
```javascript
export default function ProductsIndex({ products = [] }) {
  return MainLayout({
    title: 'Products',
    children: html`
      <h1>Products</h1>
      ${renderProductTable(products)}
    `
  })
}
```

### Inertia.js Setup
```javascript
import { createInertiaApp } from '@inertiajs/core'

createInertiaApp({
  resolve: async (name) => {
    const pageModule = await pages[name]()
    return pageModule.default || pageModule
  },
  setup({ el, App, props }) {
    render(App(props), el)
  }
})
```

## Troubleshooting

### Frontend Build Issues

If you encounter build issues:
```bash
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Database Issues

If you encounter database issues, try resetting:
```bash
rails db:drop db:create db:migrate db:seed
```

### Missing Dependencies

Ensure all gems and npm packages are installed:
```bash
bundle install
npm install
```

## Project Structure Comparison

### React Version
```
app/frontend/
├── entrypoints/application.tsx
├── pages/Products/Index.tsx
├── components/ui/button.tsx
└── layouts/MainLayout.tsx
```

### Juris.js Version
```
app/frontend/
├── entrypoints/application.js
├── pages/Products/Index.js
├── components/ui/button.js
└── layouts/MainLayout.js
```

## Performance Considerations

- **Bundle Size**: Juris.js version has a smaller bundle size due to minimal framework overhead
- **Runtime Performance**: Direct DOM manipulation can be faster for simple interactions
- **Development Experience**: React version provides better tooling and type safety
- **Maintainability**: React version benefits from larger ecosystem and community

## Related Documentation

- [ActiveDataFlow Parent Repository](../../../)
- [ActiveDataFlow Requirements](../../../.kiro/specs/requirements.md)
- [ActiveDataFlow Design](../../../.kiro/specs/design.md)
- [React Version Comparison](../rails8-newui/)

## License

This demo application is part of the ActiveDataFlow project.