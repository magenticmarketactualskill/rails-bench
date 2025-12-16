import { html } from '@/lib/juris'
import { Button } from '@/components/ui/button'

export function MainLayout({ children, title = '', flash = {} }) {
  const currentPath = window.location.pathname
  
  const isActive = (path) => currentPath.startsWith(path)
  
  const renderFlashMessage = (message, type) => {
    if (!message) return ''
    
    const typeClasses = {
      notice: 'bg-green-50 text-green-700 border-green-200',
      alert: 'bg-red-50 text-red-700 border-red-200'
    }
    
    return html`
      <div class="mb-8 p-4 rounded-lg border ${typeClasses[type] || typeClasses.notice}">
        ${message}
      </div>
    `
  }
  
  return html`
    <div class="bg-gray-50 text-gray-900 font-sans antialiased flex flex-col min-h-screen">
      <header class="bg-white shadow-sm sticky top-0 z-50">
        <nav class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <div class="flex items-center gap-8">
            <a href="/" class="flex items-center gap-2 text-xl font-bold text-indigo-600 hover:text-indigo-700 transition-colors">
              <span class="text-2xl">⚡</span>
              <span>Rails8 Juris Demo</span>
            </a>

            <div class="hidden md:flex items-center gap-6 text-sm font-medium text-gray-500">
              <a
                href="/products"
                class="hover:text-indigo-600 transition-colors ${isActive('/products') ? 'text-indigo-600' : ''}"
              >
                Products
              </a>
              <a
                href="/product_exports"
                class="hover:text-indigo-600 transition-colors ${isActive('/product_exports') ? 'text-indigo-600' : ''}"
              >
                Exports
              </a>
              <a
                href="/active_data_flow/data_flows"
                class="hover:text-indigo-600 transition-colors ${isActive('/active_data_flow') ? 'text-indigo-600' : ''}"
              >
                DataFlows
              </a>
            </div>
          </div>

          <div class="flex items-center gap-4">
            <a href="/data_flow">
              ${Button({
                children: html`
                  <span>Trigger Heartbeat</span>
                  <span class="text-indigo-200 ml-2">💓</span>
                `,
                className: "bg-indigo-600 hover:bg-indigo-700 text-white"
              })}
            </a>
          </div>
        </nav>
      </header>

      <main class="flex-grow w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        ${renderFlashMessage(flash.notice, 'notice')}
        ${renderFlashMessage(flash.alert, 'alert')}
        ${children}
      </main>

      <footer class="bg-white border-t border-gray-200 mt-auto">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div class="flex flex-col md:flex-row justify-between items-center gap-4 text-sm text-gray-500">
            <p>&copy; ${new Date().getFullYear()} ActiveDataFlow Rails 8 Juris Demo. All rights reserved.</p>
            <div class="flex items-center gap-6">
              <a href="https://github.com/active_data_flow/active_data_flow" target="_blank" class="hover:text-indigo-600 transition-colors">GitHub</a>
              <a href="#" class="hover:text-indigo-600 transition-colors">Documentation</a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  `
}