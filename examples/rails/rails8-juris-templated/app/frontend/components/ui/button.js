import { html } from '@/lib/juris'
import { cn } from '@/lib/utils'

const buttonVariants = {
  default: "bg-indigo-600 text-white hover:bg-indigo-700",
  secondary: "bg-gray-200 text-gray-900 hover:bg-gray-300",
  outline: "border border-gray-300 bg-white text-gray-700 hover:bg-gray-50"
}

export function Button({ 
  children, 
  variant = 'default', 
  className = '', 
  onClick,
  href,
  ...props 
}) {
  const baseClasses = "inline-flex items-center px-4 py-2 rounded-md font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
  const variantClasses = buttonVariants[variant] || buttonVariants.default
  const classes = cn(baseClasses, variantClasses, className)
  
  if (href) {
    return html`
      <a href="${href}" class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
        ${children}
      </a>
    `
  }
  
  const onClickHandler = onClick ? `onclick="${onClick.toString()}"` : ''
  
  return html`
    <button class="${classes}" ${onClickHandler} ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </button>
  `
}