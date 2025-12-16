import { render } from '@/lib/juris'
import './application.css'

// Simple Juris.js application setup
// This demonstrates the framework without Inertia.js complexity

// Import page components
import HomeIndex from '@/pages/Home/Index.js'
import ProductsIndex from '@/pages/Products/Index.js'
import ProductsShow from '@/pages/Products/Show.js'
import ProductExportsIndex from '@/pages/ProductExports/Index.js'
import DataFlowsIndex from '@/pages/DataFlows/Index.js'

const pages = {
  'Home/Index': HomeIndex,
  'Products/Index': ProductsIndex,
  'Products/Show': ProductsShow,
  'ProductExports/Index': ProductExportsIndex,
  'DataFlows/Index': DataFlowsIndex
}

// Simple page resolution for demonstration
function initializeApp() {
  const appElement = document.getElementById('app')
  if (!appElement) {
    console.error('App element not found')
    return
  }

  // Get page data from Rails (would normally come from Inertia.js)
  const pageData = window.pageData || {}
  const pageName = pageData.component || 'Home/Index'
  
  console.log('Loading page:', pageName)
  console.log('Page data:', pageData)
  
  // Resolve and render the page
  const PageComponent = pages[pageName]
  if (!PageComponent) {
    console.error(`Page not found: ${pageName}`)
    render(`<div class="p-4 bg-red-50">Page not found: ${pageName}</div>`, appElement)
    return
  }
  
  try {
    const pageContent = PageComponent(pageData.props || {})
    render(pageContent, appElement)
  } catch (error) {
    console.error('Error rendering page:', error)
    render(`<div class="p-4 bg-red-50 border border-red-200 rounded">
      <h2 class="text-red-800 font-semibold">Application Error</h2>
      <p class="text-red-700">${error.message}</p>
    </div>`, appElement)
  }
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeApp)
} else {
  initializeApp()
}