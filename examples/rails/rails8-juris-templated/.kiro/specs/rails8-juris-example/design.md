# Design Document

## Overview

This design implements a Rails 8 example application called `rails8-juris` that demonstrates ActiveDataFlow functionality using Juris.js instead of React. The application replicates the functionality of the existing `rails8-newui` example while showcasing Juris.js as an alternative frontend framework. The backend remains identical to maintain focus on the frontend framework differences.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Rails 8 Application                  │
├─────────────────────────────────────────────────────────┤
│                     Backend (Identical)                 │
│  ┌────────────┐  ┌────────────┐  ┌──────────────────┐  │
│  │Controllers │  │   Models   │  │  ActiveDataFlow  │  │
│  │            │  │            │  │     Engine       │  │
│  └────────────┘  └────────────┘  └──────────────────┘  │
├─────────────────────────────────────────────────────────┤
│                    Inertia.js Bridge                    │
├─────────────────────────────────────────────────────────┤
│                 Frontend (Juris.js)                     │
│  ┌────────────┐  ┌────────────┐  ┌──────────────────┐  │
│  │   Pages    │  │ Components │  │     Layouts      │  │
│  │            │  │            │  │                  │  │
│  └────────────┘  └────────────┘  └──────────────────┘  │
├─────────────────────────────────────────────────────────┤
│                   Build System (Vite)                   │
└─────────────────────────────────────────────────────────┘
```

### Technology Stack

- **Backend**: Rails 8.1+, SQLite3, ActiveDataFlow gems
- **Frontend**: Juris.js, Inertia.js, TailwindCSS
- **Build System**: Vite with TypeScript support
- **Styling**: TailwindCSS with PostCSS

## Components and Interfaces

### 1. Backend Components (Identical to Rails8-NewUI)

**Purpose**: Maintain identical backend functionality to focus on frontend differences

**Components**:
- `ProductsController` - Handles product listing and display
- `ProductExportsController` - Handles product export listing and purging
- `Product` model - Source data model
- `ProductExport` model - Transformed data model
- `ProductSyncFlow` - ActiveDataFlow transformation logic

### 2. Juris.js Frontend Structure

**Purpose**: Implement equivalent functionality using Juris.js patterns

**Directory Structure**:
```
app/frontend/
├── entrypoints/
│   ├── application.js          # Main Juris.js entry point
│   └── application.css         # TailwindCSS styles
├── pages/
│   ├── Home/
│   │   └── Index.js           # Home page component
│   ├── Products/
│   │   ├── Index.js           # Products listing
│   │   └── Show.js            # Product detail
│   ├── ProductExports/
│   │   └── Index.js           # Product exports listing
│   └── DataFlows/
│       └── Index.js           # DataFlow management
├── components/
│   ├── ui/
│   │   ├── Table.js           # Table component
│   │   ├── Button.js          # Button component
│   │   ├── Badge.js           # Badge component
│   │   └── Card.js            # Card component
│   └── Layout/
│       └── MainLayout.js      # Main application layout
└── lib/
    └── utils.js               # Utility functions
```

### 3. Inertia.js Integration

**Purpose**: Bridge Rails backend with Juris.js frontend

**Configuration**:
- Inertia Rails adapter for server-side rendering
- Juris.js Inertia adapter for client-side handling
- Page component resolution and props passing

## Data Models

### Database Schema (Identical to Rails8-NewUI)

The database schema remains identical to the Rails8-NewUI example:

#### products table
```ruby
create_table :products do |t|
  t.string :sku, null: false
  t.string :name, null: false
  t.decimal :price, precision: 10, scale: 2, null: false
  t.string :category, null: false
  t.boolean :active, default: true, null: false
  t.timestamps
end
```

#### product_exports table
```ruby
create_table :product_exports do |t|
  t.references :product, null: false, foreign_key: true
  t.string :sku, null: false
  t.string :name, null: false
  t.integer :price_cents, null: false
  t.string :category_slug, null: false
  t.datetime :exported_at, null: false
  t.timestamps
end
```

## Juris.js Component Patterns

### 1. Component Definition

Juris.js components follow a functional approach with reactive state management:

```javascript
// Example: Button component
import { html, css } from 'juris'

export const Button = ({ children, onClick, variant = 'primary', ...props }) => {
  const baseClasses = 'px-4 py-2 rounded-md font-medium transition-colors'
  const variantClasses = {
    primary: 'bg-indigo-600 text-white hover:bg-indigo-700',
    secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300'
  }
  
  return html`
    <button 
      class="${baseClasses} ${variantClasses[variant]}"
      onclick=${onClick}
      ...${props}
    >
      ${children}
    </button>
  `
}
```

### 2. Page Components

Page components receive props from Inertia.js and render the complete page:

```javascript
// Example: Products Index page
import { html } from 'juris'
import { MainLayout } from '../components/Layout/MainLayout.js'
import { Table } from '../components/ui/Table.js'

export default function ProductsIndex({ products }) {
  return MainLayout({
    title: 'Products',
    children: html`
      <div>
        <h1 class="text-4xl font-bold text-gray-900 mb-8">📦 Products</h1>
        ${Table({
          headers: ['ID', 'SKU', 'Name', 'Price', 'Category', 'Active'],
          rows: products.map(product => [
            product.id,
            product.sku,
            product.name,
            `$${Number(product.price).toFixed(2)}`,
            product.category,
            product.active ? 'Active' : 'Inactive'
          ])
        })}
      </div>
    `
  })
}
```

### 3. State Management

Juris.js uses reactive state management for dynamic interactions:

```javascript
import { state, html } from 'juris'

export const InteractiveComponent = () => {
  const [count, setCount] = state(0)
  
  return html`
    <div>
      <p>Count: ${count}</p>
      <button onclick=${() => setCount(count + 1)}>
        Increment
      </button>
    </div>
  `
}
```

## Error Handling

### Frontend Error Handling

1. **Component Error Boundaries**: Implement error boundaries for graceful degradation
2. **Network Error Handling**: Handle Inertia.js request failures
3. **Validation Errors**: Display form validation errors from Rails
4. **404 Handling**: Custom 404 pages for missing resources

### Build System Error Handling

1. **TypeScript Errors**: Compile-time type checking
2. **Linting Errors**: ESLint configuration for code quality
3. **Build Failures**: Clear error messages for development

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

Property 1: Controller behavior consistency
*For any* controller action in Rails8-Juris, the response should be identical to the corresponding action in Rails8-NewUI when given the same input data
**Validates: Requirements 2.1, 2.2**

Property 2: Model behavior consistency  
*For any* model operation in Rails8-Juris, the result should be identical to the corresponding operation in Rails8-NewUI
**Validates: Requirements 2.3, 2.4**

Property 3: UI component data rendering
*For any* valid data input to Juris.js components, all required data fields should be rendered in the output HTML
**Validates: Requirements 4.1, 4.2, 4.3, 4.4**

Property 4: TailwindCSS class consistency
*For any* Juris.js component, the CSS classes applied should match the equivalent React component in Rails8-NewUI
**Validates: Requirements 4.5**

Property 5: Flash message display
*For any* flash message data passed to the layout, the message should be rendered with appropriate styling based on message type
**Validates: Requirements 5.4**

Property 6: Product table data completeness
*For any* product data array, the rendered table should contain all required columns (ID, SKU, name, price, category, active status) for each product
**Validates: Requirements 6.1**

Property 7: Product export table data completeness
*For any* product export data array, the rendered table should contain all required columns (product ID, SKU, name, price cents, category slug, exported date) for each export
**Validates: Requirements 6.2**

Property 8: Badge color consistency
*For any* boolean active status, the badge component should render with green styling for true values and gray styling for false values
**Validates: Requirements 6.4**

Property 9: Price and date formatting consistency
*For any* numeric price or date value, the formatted output should follow consistent patterns (currency format for prices, readable format for dates)
**Validates: Requirements 6.5**

## Testing Strategy

### Unit Testing

1. **Component Testing**: Test individual Juris.js components
2. **Utility Function Testing**: Test helper functions and utilities
3. **Integration Testing**: Test component interactions

### Property-Based Testing

The model will use Jest as the testing framework for property-based testing. Each property-based test will run a minimum of 100 iterations to ensure comprehensive coverage. Property-based tests will be tagged with comments referencing the design document properties using the format: **Feature: rails8-juris-example, Property {number}: {property_text}**.
