import { html } from '@/lib/juris'
import { MainLayout } from '@/layouts/MainLayout'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { Button } from '@/components/ui/button'

export default function HomeIndex(props) {
  return MainLayout({
    title: 'Home',
    flash: props.flash || {},
    children: html`
      <div class="space-y-8">
        <div class="text-center">
          <h1 class="text-4xl font-bold text-gray-900 mb-4">
            🚀 Rails 8 + Juris.js Demo
          </h1>
          <p class="text-xl text-gray-600 mb-8">
            ActiveDataFlow demonstration using Juris.js instead of React
          </p>
        </div>

        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          ${Card({
            children: html`
              ${CardHeader({
                children: html`
                  <h3 class="text-lg font-semibold text-gray-900">📦 Products</h3>
                `
              })}
              ${CardContent({
                children: html`
                  <p class="text-gray-600 mb-4">
                    View and manage the product catalog. This is the source data for our DataFlow transformations.
                  </p>
                  <a href="/products">
                    ${Button({
                      children: 'View Products',
                      className: 'w-full'
                    })}
                  </a>
                `
              })}
            `
          })}

          ${Card({
            children: html`
              ${CardHeader({
                children: html`
                  <h3 class="text-lg font-semibold text-gray-900">📊 Product Exports</h3>
                `
              })}
              ${CardContent({
                children: html`
                  <p class="text-gray-600 mb-4">
                    View transformed product data. This shows the results of our ActiveDataFlow processing.
                  </p>
                  <a href="/product_exports">
                    ${Button({
                      children: 'View Exports',
                      variant: 'secondary',
                      className: 'w-full'
                    })}
                  </a>
                `
              })}
            `
          })}

          ${Card({
            children: html`
              ${CardHeader({
                children: html`
                  <h3 class="text-lg font-semibold text-gray-900">⚡ DataFlows</h3>
                `
              })}
              ${CardContent({
                children: html`
                  <p class="text-gray-600 mb-4">
                    Monitor and manage ActiveDataFlow processes. Trigger data transformations and view execution status.
                  </p>
                  <a href="/active_data_flow/data_flows">
                    ${Button({
                      children: 'View DataFlows',
                      variant: 'outline',
                      className: 'w-full'
                    })}
                  </a>
                `
              })}
            `
          })}
        </div>

        <div class="bg-blue-50 border border-blue-200 rounded-lg p-6">
          <h2 class="text-lg font-semibold text-blue-900 mb-2">
            🎯 About This Demo
          </h2>
          <p class="text-blue-800 mb-4">
            This application demonstrates the same ActiveDataFlow functionality as the React version, 
            but implemented using Juris.js as the frontend framework. It showcases how ActiveDataFlow 
            can work with different frontend technologies while maintaining identical backend behavior.
          </p>
          <div class="flex flex-wrap gap-4">
            <a href="/products">
              ${Button({
                children: 'Start Exploring',
                variant: 'default'
              })}
            </a>
            <a href="/data_flow">
              ${Button({
                children: 'Trigger DataFlow',
                variant: 'outline'
              })}
            </a>
          </div>
        </div>
      </div>
    `
  })
}