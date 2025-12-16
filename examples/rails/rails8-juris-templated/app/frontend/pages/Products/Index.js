import { html } from '@/lib/juris'
import { MainLayout } from '@/layouts/MainLayout'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Badge } from '@/components/ui/badge'

export default function ProductsIndex({ products = [], flash = {} }) {
  const renderProductRow = (product) => {
    return TableRow({
      children: html`
        ${TableCell({ children: product.id.toString() })}
        ${TableCell({ children: product.sku })}
        ${TableCell({ children: product.name })}
        ${TableCell({ children: `$${Number(product.price).toFixed(2)}` })}
        ${TableCell({ children: product.category })}
        ${TableCell({ 
          children: Badge({
            variant: product.active ? "success" : "secondary",
            className: product.active ? "bg-green-100 text-green-800" : "bg-gray-100 text-gray-800",
            children: product.active ? 'Active' : 'Inactive'
          })
        })}
      `,
      className: "hover:bg-gray-50"
    })
  }

  return MainLayout({
    title: 'Products',
    flash,
    children: html`
      <div>
        <div class="mb-6">
          <a href="/" class="text-indigo-600 hover:text-indigo-700 font-medium">← Back to Home</a>
        </div>

        <h1 class="text-4xl font-bold text-gray-900 mb-8">📦 Products</h1>

        <div class="flex flex-wrap items-center gap-4 mb-8 text-sm">
          <a href="/product_exports" class="text-indigo-600 hover:text-indigo-700 font-medium">View Product Exports</a>
          <span class="text-gray-400">|</span>
          <a href="/active_data_flow/data_flows" class="text-indigo-600 hover:text-indigo-700 font-medium">View DataFlow</a>
          <span class="text-gray-400">|</span>
          <a href="/data_flow" class="text-indigo-600 hover:text-indigo-700 font-medium">Trigger Heartbeat</a>
        </div>

        <div class="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-200">
          ${Table({
            children: html`
              ${TableHeader({
                className: "bg-gray-50",
                children: TableRow({
                  children: html`
                    ${TableHead({ children: 'ID' })}
                    ${TableHead({ children: 'SKU' })}
                    ${TableHead({ children: 'Name' })}
                    ${TableHead({ children: 'Price' })}
                    ${TableHead({ children: 'Category' })}
                    ${TableHead({ children: 'Active' })}
                  `
                })
              })}
              ${TableBody({
                children: products.map(renderProductRow).join('')
              })}
            `
          })}
        </div>
      </div>
    `
  })
}