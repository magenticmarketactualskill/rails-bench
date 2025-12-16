# Implementation Plan

- [x] 1. Set up project structure and Rails configuration
  - Create Rails 8 application in `submodules/examples/rails8-juris` directory
  - Copy Rails configuration files from rails8-newui (application.rb, routes.rb, etc.)
  - Set up database configuration and initializers
  - _Requirements: 1.1, 1.2_

- [ ] 2. Configure backend models and controllers
- [x] 2.1 Copy Product and ProductExport models from rails8-newui
  - Copy model files with identical attributes and validations
  - Copy database migrations for products and product_exports tables
  - _Requirements: 2.3, 2.5_

- [ ] 2.2 Write property test for model consistency
  - **Property 2: Model behavior consistency**
  - **Validates: Requirements 2.3, 2.4**

- [x] 2.3 Copy ProductsController and ProductExportsController from rails8-newui
  - Copy controller files with identical action implementations
  - Ensure Inertia.js rendering calls are properly configured
  - _Requirements: 2.1, 2.2_

- [ ] 2.4 Write property test for controller consistency
  - **Property 1: Controller behavior consistency**
  - **Validates: Requirements 2.1, 2.2**

- [x] 2.5 Copy ProductSyncFlow DataFlow from rails8-newui
  - Copy DataFlow implementation with identical transformation logic
  - _Requirements: 2.4_

- [ ] 3. Set up frontend build system and dependencies
- [x] 3.1 Configure Vite build system
  - Create vite.config.js with Juris.js support
  - Configure TypeScript support for Juris.js components
  - _Requirements: 7.1, 7.4_

- [x] 3.2 Set up package.json with Juris.js dependencies
  - Add Juris.js and Inertia.js Juris adapter
  - Add TailwindCSS and PostCSS dependencies
  - Add development and production build scripts
  - _Requirements: 1.3, 1.4, 7.2, 7.3, 7.5_

- [x] 3.3 Configure TailwindCSS and PostCSS
  - Create tailwind.config.js with same configuration as rails8-newui
  - Set up PostCSS configuration
  - _Requirements: 7.3_

- [ ] 4. Implement Juris.js UI components
- [x] 4.1 Create base UI components
  - Implement Button component with variants and event handling
  - Implement Badge component with color variants
  - Implement Card component for content containers
  - _Requirements: 4.2, 4.3, 4.4_

- [ ] 4.2 Write property tests for UI components
  - **Property 3: UI component data rendering**
  - **Property 8: Badge color consistency**
  - **Validates: Requirements 4.1, 4.2, 4.3, 4.4, 6.4**

- [x] 4.3 Create Table component
  - Implement table with headers and rows support
  - Add styling consistent with rails8-newui
  - _Requirements: 4.1_

- [ ] 4.4 Write property test for Table component
  - **Property 6: Product table data completeness**
  - **Property 7: Product export table data completeness**
  - **Validates: Requirements 6.1, 6.2**

- [x] 4.5 Ensure TailwindCSS class consistency
  - Verify all components use identical CSS classes to React version
  - _Requirements: 4.5_

- [ ] 4.6 Write property test for CSS consistency
  - **Property 4: TailwindCSS class consistency**
  - **Validates: Requirements 4.5**

- [ ] 5. Create layout and navigation components
- [x] 5.1 Implement MainLayout component
  - Create layout with header, navigation, main content, and footer
  - Include flash message display functionality
  - _Requirements: 5.1, 5.4, 5.5_

- [ ] 5.2 Write property test for flash messages
  - **Property 5: Flash message display**
  - **Validates: Requirements 5.4**

- [x] 5.3 Add navigation links and trigger button
  - Implement navigation to Products, Exports, and DataFlows pages
  - Add "Trigger Heartbeat" button in navigation
  - _Requirements: 5.2, 5.3_

- [ ] 6. Implement page components
- [x] 6.1 Create Home/Index page
  - Implement home page with welcome content and navigation links
  - _Requirements: 3.4_

- [x] 6.2 Create Products/Index page
  - Implement products listing with table display
  - Include navigation links and product data rendering
  - _Requirements: 3.1, 6.1_

- [x] 6.3 Create Products/Show page
  - Implement individual product display page
  - _Requirements: 3.2_

- [x] 6.4 Create ProductExports/Index page
  - Implement product exports listing with table display
  - Include purge functionality
  - _Requirements: 3.3, 6.2, 6.3_

- [x] 6.5 Create DataFlows/Index page
  - Implement DataFlow management page
  - _Requirements: 3.5_

- [ ] 6.6 Write property test for data formatting
  - **Property 9: Price and date formatting consistency**
  - **Validates: Requirements 6.5**

- [ ] 7. Configure Inertia.js integration
- [x] 7.1 Set up Inertia.js Rails adapter
  - Configure Inertia middleware and helpers
  - Set up page component resolution
  - _Requirements: 1.4_

- [x] 7.2 Create Juris.js Inertia application entry point
  - Set up main application.js with Inertia and Juris.js integration
  - Configure page component loading and props handling
  - _Requirements: 1.4_

- [ ] 8. Add ActiveDataFlow gem dependencies
- [x] 8.1 Configure Gemfile with ActiveDataFlow gems
  - Add identical gem dependencies from rails8-newui
  - Include path references to parent repository gems
  - _Requirements: 1.5_

- [x] 8.2 Set up ActiveDataFlow initializers
  - Copy ActiveDataFlow configuration from rails8-newui
  - _Requirements: 1.5_

- [ ] 9. Create documentation
- [x] 9.1 Write comprehensive README.md
  - Document project setup and installation instructions
  - Include examples of Juris.js component patterns
  - Document differences between React and Juris.js implementations
  - Document Inertia.js and Rails integration
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

- [ ] 10. Final testing and verification
- [x] 10.1 Ensure all tests pass
  - Run all property-based tests and unit tests
  - Verify application functionality matches rails8-newui
  - Ask the user if questions arise

- [ ] 10.2 Write integration tests
  - Create end-to-end tests for complete user workflows
  - Test DataFlow execution and data transformation