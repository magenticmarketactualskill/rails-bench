// Simple Juris.js-like framework implementation
// This is a minimal implementation for demonstration purposes

export function html(strings, ...values) {
  let result = strings[0];
  for (let i = 0; i < values.length; i++) {
    const value = values[i];
    if (typeof value === 'function') {
      result += value();
    } else if (Array.isArray(value)) {
      result += value.join('');
    } else {
      result += value || '';
    }
    result += strings[i + 1];
  }
  return result;
}

export function component(fn) {
  return fn;
}

export function render(element, container) {
  if (typeof element === 'string') {
    container.innerHTML = element;
  } else if (typeof element === 'function') {
    container.innerHTML = element();
  }
}

export function createElement(tag, props = {}, ...children) {
  const element = document.createElement(tag);
  
  // Set attributes
  Object.keys(props).forEach(key => {
    if (key.startsWith('on') && typeof props[key] === 'function') {
      element.addEventListener(key.slice(2).toLowerCase(), props[key]);
    } else if (key === 'className') {
      element.className = props[key];
    } else {
      element.setAttribute(key, props[key]);
    }
  });
  
  // Add children
  children.forEach(child => {
    if (typeof child === 'string') {
      element.appendChild(document.createTextNode(child));
    } else if (child instanceof Node) {
      element.appendChild(child);
    }
  });
  
  return element;
}

// State management
export function useState(initialValue) {
  let value = initialValue;
  const listeners = [];
  
  const setValue = (newValue) => {
    value = newValue;
    listeners.forEach(listener => listener(value));
  };
  
  const getValue = () => value;
  
  const subscribe = (listener) => {
    listeners.push(listener);
    return () => {
      const index = listeners.indexOf(listener);
      if (index > -1) listeners.splice(index, 1);
    };
  };
  
  return [getValue, setValue, subscribe];
}

// Utility functions
export function cn(...classes) {
  return classes.filter(Boolean).join(' ');
}