import { html } from '@/lib/juris'
import { cn } from '@/lib/utils'

export function Card({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("bg-white rounded-lg shadow-sm border border-gray-200", className)
  
  return html`
    <div class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </div>
  `
}

export function CardHeader({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("px-6 py-4 border-b border-gray-200", className)
  
  return html`
    <div class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </div>
  `
}

export function CardContent({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("px-6 py-4", className)
  
  return html`
    <div class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </div>
  `
}

export function CardFooter({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("px-6 py-4 border-t border-gray-200", className)
  
  return html`
    <div class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </div>
  `
}