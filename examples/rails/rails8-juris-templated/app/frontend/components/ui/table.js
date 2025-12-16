import { html } from '@/lib/juris'
import { cn } from '@/lib/utils'

export function Table({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("w-full caption-bottom text-sm", className)
  
  return html`
    <table class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </table>
  `
}

export function TableHeader({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("", className)
  
  return html`
    <thead class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </thead>
  `
}

export function TableBody({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("", className)
  
  return html`
    <tbody class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </tbody>
  `
}

export function TableRow({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted", className)
  
  return html`
    <tr class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </tr>
  `
}

export function TableHead({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("h-12 px-4 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0", className)
  
  return html`
    <th class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </th>
  `
}

export function TableCell({ 
  children, 
  className = '',
  ...props 
}) {
  const classes = cn("p-4 align-middle [&:has([role=checkbox])]:pr-0", className)
  
  return html`
    <td class="${classes}" ${Object.entries(props).map(([k, v]) => `${k}="${v}"`).join(' ')}>
      ${children}
    </td>
  `
}