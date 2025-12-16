# Child Component Requirements

## Introduction

This document specifies what child components (runtimes and connectors) need to know when implementing ActiveDataFlow interfaces.

See main requirements: `.kiro/specs/requirements.md`

## Requirements for Child Components

### For Runtime Implementations

See: `.kiro/specs/toChildren/runtime/requirements.md`
See: `.kiro/specs/requirements.md` (Requirements 7-9, 14)

### For Connector Implementations

See: `.kiro/specs/toChildren/connector/` subdirectories
See: `.kiro/specs/requirements.md` (Requirements 1-6, 15)

## Core Interfaces to Implement

Child components must implement the abstract classes defined in the core gem:
- Runtimes extend `ActiveDataFlow::Runtime`
- Sources extend `ActiveDataFlow::Connector::Source`
- Sinks extend `ActiveDataFlow::Connector::Sink`
