# Requirements Document

## Introduction

This document specifies the requirements for creating a Rails 8 example application called `rails8-juris` that demonstrates ActiveDataFlow functionality using Juris.js instead of React. The application will be modeled after the existing `rails8-newui` example but will use Juris.js as the frontend framework while maintaining the same controllers, models, and data flow patterns.

## Glossary

- **Rails8-Juris**: The new Rails 8 example application using Juris.js
- **Juris.js**: A JavaScript framework for building user interfaces (https://jurisjs.com/)
- **ActiveDataFlow**: The Ruby gem suite for Rails applications providing stream processing patterns
- **Inertia.js**: The adapter that connects Rails backend to frontend frameworks
- **ProductSyncFlow**: The DataFlow that demonstrates data transformation from products to product exports
- **Rails8-NewUI**: The existing Rails 8 example application using React that serves as the model

## Requirements

### Requirement 1: Project Structure and Setup

**User Story:** As a developer, I want a Rails 8 application with Juris.js frontend, so that I can demonstrate ActiveDataFlow functionality using Juris instead of React.

#### Acceptance Criteria

1. THE Rails8-Juris application SHALL be created in the `submodules/examples/rails8-juris` directory
2. THE Rails8-Juris application SHALL use the same Rails 8 configuration as Rails8-NewUI
3. THE Rails8-Juris application SHALL use Juris.js instead of React for the frontend framework
4. THE Rails8-Juris application SHALL use Inertia.js to connect Rails backend to Juris.js frontend
5. THE Rails8-Juris application SHALL include all the same ActiveDataFlow gem dependencies as Rails8-NewUI

### Requirement 2: Backend Controllers and Models

**User Story:** As a developer, I want identical backend functionality to Rails8-NewUI, so that I can focus on demonstrating the Juris.js frontend differences.

#### Acceptance Criteria

1. THE Rails8-Juris application SHALL include identical ProductsController to Rails8-NewUI
2. THE Rails8-Juris application SHALL include identical ProductExportsController to Rails8-NewUI
3. THE Rails8-Juris application SHALL include identical Product and ProductExport models to Rails8-NewUI
4. THE Rails8-Juris application SHALL include identical ProductSyncFlow DataFlow to Rails8-NewUI
5. THE Rails8-Juris application SHALL include identical database migrations to Rails8-NewUI

### Requirement 3: Juris.js Frontend Components

**User Story:** As a developer, I want Juris.js components that replicate the React functionality, so that I can demonstrate equivalent user interface capabilities.

#### Acceptance Criteria

1. THE Rails8-Juris application SHALL implement a Products/Index page using Juris.js
2. THE Rails8-Juris application SHALL implement a Products/Show page using Juris.js
3. THE Rails8-Juris application SHALL implement a ProductExports/Index page using Juris.js
4. THE Rails8-Juris application SHALL implement a Home/Index page using Juris.js
5. THE Rails8-Juris application SHALL implement a DataFlows/Index page using Juris.js

### Requirement 4: UI Component Library

**User Story:** As a developer, I want reusable UI components in Juris.js, so that I can maintain consistent styling and behavior across pages.

#### Acceptance Criteria

1. THE Rails8-Juris application SHALL implement Table components using Juris.js
2. THE Rails8-Juris application SHALL implement Button components using Juris.js
3. THE Rails8-Juris application SHALL implement Badge components using Juris.js
4. THE Rails8-Juris application SHALL implement Card components using Juris.js
5. THE Rails8-Juris application SHALL use TailwindCSS for styling identical to Rails8-NewUI

### Requirement 5: Layout and Navigation

**User Story:** As a developer, I want consistent layout and navigation, so that users can navigate between different sections of the application.

#### Acceptance Criteria

1. THE Rails8-Juris application SHALL implement a MainLayout component using Juris.js
2. THE Rails8-Juris application SHALL include navigation links to Products, Exports, and DataFlows pages
3. THE Rails8-Juris application SHALL include a "Trigger Heartbeat" button in the navigation
4. THE Rails8-Juris application SHALL display flash messages for notices and alerts
5. THE Rails8-Juris application SHALL include a footer with copyright and links

### Requirement 6: Data Display and Interaction

**User Story:** As a developer, I want to display and interact with data, so that I can demonstrate the full application functionality.

#### Acceptance Criteria

1. THE Rails8-Juris application SHALL display products in a table with ID, SKU, name, price, category, and active status
2. THE Rails8-Juris application SHALL display product exports in a table with product ID, SKU, name, price cents, category slug, and exported date
3. THE Rails8-Juris application SHALL provide a purge functionality for product exports
4. THE Rails8-Juris application SHALL show active/inactive status using colored badges
5. THE Rails8-Juris application SHALL format prices and dates appropriately

### Requirement 7: Build System and Dependencies

**User Story:** As a developer, I want a proper build system, so that I can develop and deploy the Juris.js application.

#### Acceptance Criteria

1. THE Rails8-Juris application SHALL use Vite as the build system
2. THE Rails8-Juris application SHALL include Juris.js and related dependencies in package.json
3. THE Rails8-Juris application SHALL include TailwindCSS and PostCSS configuration
4. THE Rails8-Juris application SHALL include TypeScript support for Juris.js components
5. THE Rails8-Juris application SHALL include development and production build scripts

### Requirement 8: Documentation and Examples

**User Story:** As a developer, I want clear documentation, so that I can understand how to use Juris.js with Rails and ActiveDataFlow.

#### Acceptance Criteria

1. THE Rails8-Juris application SHALL include a comprehensive README.md file
2. THE Rails8-Juris application SHALL document the differences between React and Juris.js implementations
3. THE Rails8-Juris application SHALL include setup and installation instructions
4. THE Rails8-Juris application SHALL include examples of Juris.js component patterns
5. THE Rails8-Juris application SHALL document the integration with Inertia.js and Rails