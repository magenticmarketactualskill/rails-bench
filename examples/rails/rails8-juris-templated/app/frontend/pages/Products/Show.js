import { html } from '@/lib/juris'
import { MainLayout } from '@/layouts/MainLayout'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'

export default function ProductsShow({ product = {}, flash = {} }) {
  return MainLayout({
    title: `Product: ${product.name}`,
    flash,
    children: html`
      <div>
        <div class="mb-6">
          <a href="/products" class="text-indigo-600 hover:text-indigo-700 font-medium">← Back to Products</a>
        </div>

        <div class="mb-8">
          <h1 class="text-4xl font-bold text-gray-900 mb-2">📦 ${product.name}</h1>
          <p class="text-gray-600">Product Details</p>
        </div>

        <div class="grid md:grid-cols-2 gap-8">
          ${Card({
            children: html`
              ${CardHeader({
                children: html`
                  <h2 class="text-xl font-semibold text-gray-900">Product Information</h2>
                `
              })}
              ${CardContent({
                children: html`
                  <dl class="space-y-4">
                    <div>
                      <dt class="text-sm font-medium text-gray-500">ID</dt>
                      <dd class="text-lg text-gray-900">${product.id}</dd>
                    </div>
                    <div>
                      <dt class="text-sm font-medium text-gray-500">SKU</dt>
                      <dd class="text-lg text-gray-900 font-mono">${product.sku}</dd>
                    </div>
                    <div>
                      <dt class="text-sm font-medium text-gray-500">Name</dt>
                      <dd class="text-lg text-gray-900">${product.name}</dd>
                    </div>
                    <div>
                      <dt class="text-sm font-medium text-gray-500">Price</dt>
                      <dd class="text-lg text-gray-900 font-semibold">$${Number(product.price).toFixed(2)}</dd>
                    </div>
                    <div>
                      <dt class="text-sm font-medium text-gray-500">Category</dt>
                      <dd class="text-lg text-gray-900">${product.category}</dd>
                    </div>
                    <div>
                      <dt class="text-sm font-medium text-gray-500">Status</dt>
                      <dd class="text-lg">
                        ${Badge({
                          variant: product.active ? "success" : "secondary",
                          className: product.active ? "bg-green-100 text-green-800" : "bg-gray-100 text-gray-800",
                          children: product.active ? 'Active' : 'Inactive'
                        })}
                      </dd>
                    </div>
                  </dl>
                `
              })}
            `
          })}

          ${Card({
            children: html`
              ${CardHeader({
                children: html`
                  <h2 class="text-xl font-semibold text-gray-900">Actions</h2>
                `
              })}
              ${CardContent({
                children: html`
                  <div class="space-y-4">
                    <p class="text-gray-600">
                      This product ${product.active ? 'is active and will be included' : 'is inactive and will be excluded'} 
                      in DataFlow transformations.
                    </p>
                    <div class="flex flex-col gap-3">
                      <a href="/products">
                        ${Button({
                          children: 'Back to Products',
                          variant: 'outline',
                          className: 'w-full'
                        })}
                      </a>
                      <a href="/product_exports">
                        ${Button({
                          children: 'View Product Exports',
                          variant: 'secondary',
                          className: 'w-full'
                        })}
                      </a>
                      <a href="/data_flow">
                        ${Button({
                          children: 'Trigger DataFlow',
                          className: 'w-full'
                        })}
                      </a>
                    </div>
                  </div>
                `
              })}
            `
          })}
        </div>
      </div>
    `
  })
}