import { html } from '@/lib/juris'
import { MainLayout } from '@/layouts/MainLayout'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'

export default function DataFlowsIndex({ data_flows = [], flash = {} }) {
  const renderDataFlowCard = (dataFlow) => {
    return Card({
      className: "mb-6",
      children: html`
        ${CardHeader({
          children: html`
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-gray-900">${dataFlow.name || 'ProductSyncFlow'}</h3>
              ${Badge({
                variant: dataFlow.status === 'active' ? 'success' : 'secondary',
                children: dataFlow.status || 'Ready'
              })}
            </div>
          `
        })}
        ${CardContent({
          children: html`
            <div class="space-y-4">
              <p class="text-gray-600">
                Synchronizes active products to the export table with data transformation.
              </p>
              
              <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                <div>
                  <dt class="font-medium text-gray-500">Source</dt>
                  <dd class="text-gray-900">Products Table</dd>
                </div>
                <div>
                  <dt class="font-medium text-gray-500">Destination</dt>
                  <dd class="text-gray-900">Product Exports</dd>
                </div>
                <div>
                  <dt class="font-medium text-gray-500">Last Run</dt>
                  <dd class="text-gray-900">${dataFlow.last_run || 'Never'}</dd>
                </div>
                <div>
                  <dt class="font-medium text-gray-500">Records Processed</dt>
                  <dd class="text-gray-900">${dataFlow.records_processed || '0'}</dd>
                </div>
              </div>

              <div class="flex gap-3">
                <a href="/data_flow">
                  ${Button({
                    children: 'Trigger Execution',
                    className: 'flex-1'
                  })}
                </a>
                ${Button({
                  children: 'View Logs',
                  variant: 'outline',
                  className: 'flex-1'
                })}
              </div>
            </div>
          `
        })}
      `
    })
  }

  return MainLayout({
    title: 'DataFlows',
    flash,
    children: html`
      <div>
        <div class="mb-6">
          <a href="/" class="text-indigo-600 hover:text-indigo-700 font-medium">← Back to Home</a>
        </div>

        <div class="flex items-center justify-between mb-8">
          <div>
            <h1 class="text-4xl font-bold text-gray-900 mb-2">⚡ DataFlows</h1>
            <p class="text-gray-600">ActiveDataFlow process management and monitoring</p>
          </div>
          
          <a href="/data_flow">
            ${Button({
              children: html`
                <span>Trigger Heartbeat</span>
                <span class="ml-2">💓</span>
              `
            })}
          </a>
        </div>

        <div class="flex flex-wrap items-center gap-4 mb-8 text-sm">
          <a href="/products" class="text-indigo-600 hover:text-indigo-700 font-medium">View Products</a>
          <span class="text-gray-400">|</span>
          <a href="/product_exports" class="text-indigo-600 hover:text-indigo-700 font-medium">View Product Exports</a>
        </div>

        ${data_flows.length === 0 ? html`
          <div class="space-y-6">
            ${renderDataFlowCard({
              name: 'ProductSyncFlow',
              status: 'ready',
              last_run: 'Never',
              records_processed: 0
            })}
            
            <div class="bg-blue-50 border border-blue-200 rounded-lg p-6">
              <h2 class="text-lg font-semibold text-blue-900 mb-2">
                🎯 How DataFlows Work
              </h2>
              <div class="text-blue-800 space-y-2">
                <p>
                  DataFlows process data through a simple pipeline:
                </p>
                <ol class="list-decimal list-inside space-y-1 ml-4">
                  <li><strong>Source:</strong> Read active products from the database</li>
                  <li><strong>Transform:</strong> Convert prices to cents and generate category slugs</li>
                  <li><strong>Sink:</strong> Write transformed data to the product exports table</li>
                </ol>
                <p class="mt-4">
                  Click "Trigger Heartbeat" to start processing products through the DataFlow.
                </p>
              </div>
            </div>
          </div>
        ` : html`
          <div class="space-y-6">
            ${data_flows.map(renderDataFlowCard).join('')}
          </div>
        `}
      </div>
    `
  })
}