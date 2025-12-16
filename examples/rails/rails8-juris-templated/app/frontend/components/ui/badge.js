import { html } from '@/lib/juris'
import { cn } from '@/lib/utils'

const badgeVariants = {
  default: "bg-indigo-100 text-indigo-800",
  secondary: "bg-gray-100 text-gray-800",
  success: "bg-green-100 text-green-800",
  warning: "bg-yellow-100 text-yellow-800",
  error: "bg-red-100 text-red-800"
}

export function Badge({ 
  children, 
  variant = 'default', 
  className = '',
  ...props 
}) {
  const baseClasses = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
  const variantClasses = badgeVariants[variant] || badgeVariants.default
  const classes = cn(baseClasses, variantClasses, className)
  
  return html`
    <span class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </span>
  `
}