import { html } from '@/lib/juris'
import { MainLayout } from '@/layouts/MainLayout'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Button } from '@/components/ui/button'

export default function ProductExportsIndex({ product_exports = [], flash = {} }) {
  const formatDate = (dateString) => {
    if (!dateString) return 'N/A'
    return new Date(dateString).toLocaleString()
  }

  const formatPriceCents = (cents) => {
    return `$${(cents / 100).toFixed(2)}`
  }

  const renderExportRow = (productExport) => {
    return TableRow({
      children: html`
        ${TableCell({ children: productExport.product_id.toString() })}
        ${TableCell({ children: productExport.sku })}
        ${TableCell({ children: productExport.name })}
        ${TableCell({ children: formatPriceCents(productExport.price_cents) })}
        ${TableCell({ children: productExport.category_slug })}
        ${TableCell({ children: formatDate(productExport.exported_at) })}
      `,
      className: "hover:bg-gray-50"
    })
  }

  return MainLayout({
    title: 'Product Exports',
    flash,
    children: html`
      <div>
        <div class="mb-6">
          <a href="/" class="text-indigo-600 hover:text-indigo-700 font-medium">← Back to Home</a>
        </div>

        <div class="flex items-center justify-between mb-8">
          <div>
            <h1 class="text-4xl font-bold text-gray-900 mb-2">📊 Product Exports</h1>
            <p class="text-gray-600">Transformed product data from ActiveDataFlow</p>
          </div>
          
          ${product_exports.length > 0 ? html`
            <form method="post" action="/product_exports/purge" onsubmit="return confirm('Are you sure you want to purge all product exports?')">
              ${Button({
                children: 'Purge All Exports',
                variant: 'outline',
                className: 'text-red-600 border-red-300 hover:bg-red-50'
              })}
            </form>
          ` : ''}
        </div>

        <div class="flex flex-wrap items-center gap-4 mb-8 text-sm">
          <a href="/products" class="text-indigo-600 hover:text-indigo-700 font-medium">View Products</a>
          <span class="text-gray-400">|</span>
          <a href="/active_data_flow/data_flows" class="text-indigo-600 hover:text-indigo-700 font-medium">View DataFlow</a>
          <span class="text-gray-400">|</span>
          <a href="/data_flow" class="text-indigo-600 hover:text-indigo-700 font-medium">Trigger Heartbeat</a>
        </div>

        ${product_exports.length === 0 ? html`
          <div class="bg-gray-50 border border-gray-200 rounded-lg p-8 text-center">
            <div class="text-gray-400 text-6xl mb-4">📊</div>
            <h3 class="text-lg font-medium text-gray-900 mb-2">No Product Exports Yet</h3>
            <p class="text-gray-600 mb-6">
              No products have been exported yet. Trigger the DataFlow to start processing active products.
            </p>
            <a href="/data_flow">
              ${Button({
                children: 'Trigger DataFlow',
                className: 'inline-flex items-center gap-2'
              })}
            </a>
          </div>
        ` : html`
          <div class="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-200">
            ${Table({
              children: html`
                ${TableHeader({
                  className: "bg-gray-50",
                  children: TableRow({
                    children: html`
                      ${TableHead({ children: 'Product ID' })}
                      ${TableHead({ children: 'SKU' })}
                      ${TableHead({ children: 'Name' })}
                      ${TableHead({ children: 'Price' })}
                      ${TableHead({ children: 'Category Slug' })}
                      ${TableHead({ children: 'Exported At' })}
                    `
                  })
                })}
                ${TableBody({
                  children: product_exports.map(renderExportRow).join('')
                })}
              `
            })}
          </div>
        `}
      </div>
    `
  })
}