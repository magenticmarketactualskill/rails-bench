# UI Conversion Plan: Rails to Inertia v2 + Shadcn UI + React

## 1. UI Analysis
- [ ] **Audit Existing Views**: List all ERB templates in `app/views` to identify pages requiring conversion.
- [ ] **Analyze Controllers**: Identify controller actions that render views vs. those that redirect or return JSON.
- [ ] **Identify Shared Elements**: Note layouts, partials, and helpers that need to be reimplemented as React components or hooks.
- [ ] **Dependency Check**: Confirm current asset pipeline (Propshaft/Importmaps) and plan migration to Vite.

## 2. UI Design
- [ ] **Theme Setup**: Define color palette, typography, and spacing variables for Shadcn UI (using CSS variables).
- [ ] **Layout Design**: Design the main application shell (Navigation, Sidebar, Footer) in React.
- [ ] **Page Mockups**: (Optional) Create low-fidelity sketches for complex pages if structure changes significantly.

## 3. UI Component Definition
- [ ] **Core Components**: Identify necessary Shadcn components (e.g., Button, Input, Card, Table, Dialog, DropdownMenu).
- [ ] **Custom Components**: Define domain-specific components (e.g., `ProductCard`, `DataFlowStatus`).
- [ ] **Form Components**: Plan form handling strategy (using `useForm` from Inertia or `react-hook-form`).

## 4. UI Component Implementation
- [ ] **Environment Setup**:
    - [ ] Install `vite_rails` and configure `vite.config.ts`.
    - [ ] Install `inertia_rails` gem (ensure v2.0 compatibility/configuration).
    - [ ] Install React, ReactDOM, and Inertia React adapter (v2.0).
    - [ ] Install Tailwind CSS (via Vite) and `tailwindcss-animate`.
- [ ] **Shadcn Initialization**:
    - [ ] Run `npx shadcn@latest init`.
    - [ ] Configure `components.json`.
- [ ] **Component Library Build**:
    - [ ] Install/Add required Shadcn components (`npx shadcn@latest add button input ...`).
    - [ ] Implement custom components.

## 5. UI Component Integration (with existing RAILS APP)
- [ ] **Backend Configuration**:
    - [ ] Update `ApplicationController` to use `Inertia::Controller`.
    - [ ] Configure Inertia shared data (flash messages, current user).
    - [ ] **Inertia 2.0 Specifics**: Ensure any new v2 features (like polling, lazy loading improvements) are leveraged if needed.
- [ ] **Frontend Entry Point**:
    - [ ] Create `app/frontend/entrypoints/application.tsx` (or similar).
    - [ ] Set up Inertia `createInertiaApp` with page resolution.
- [ ] **Iterative Conversion**:
    - [ ] **Layout**: Replace `app/views/layouts/application.html.erb` with Inertia root view.
    - [ ] **Pages**: Convert Controller actions one by one:
        - Change `render` to `inertia 'PageName', props: { ... }`.
        - Create corresponding React page component in `app/frontend/pages/`.
- [ ] **Routing**: Ensure Rails routes map correctly to Inertia pages.

## 6. Final Delivery
- [ ] **Verification**:
    - [ ] Manual testing of all converted flows.
    - [ ] Ensure feature parity with old UI.
- [ ] **Cleanup**: Remove unused ERB views, partials, and legacy asset pipeline configuration (if fully migrated).
- [ ] **Optimization**: Check bundle size and initial load performance.
