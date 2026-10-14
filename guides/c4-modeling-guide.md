# 🗺️ C4 Architecture Modeling Guide (Structurizr DSL)

This guide explains how to document system architectures using the **C4 Model** and **Structurizr DSL** for modular full-stack systems.

---

## 🎯 What is the C4 Model?

The C4 model zooms into software systems at 4 distinct levels of abstraction, similar to Google Maps:

1. **Level 1: System Context**
   - Shows the system in its environment, including the humans who use it and external systems it integrates with.
   - Intended audience: Everyone (stakeholders, product owners, engineers).
2. **Level 2: Containers**
   - Zooms into the system boundary. A "container" is an independently deployable/runnable unit (e.g. Next.js Web App, NestJS API, PostgreSQL Database, S3 Bucket).
   - Intended audience: Technical leads, software engineers, DevOps.
3. **Level 3: Components**
   - Zooms into a specific container to show its internal modules, controllers, and services.
   - Intended audience: Engineers actively working on that codebase.
4. **Level 4: Code (Optional)**
   - Class diagrams, ERDs, or Prisma schemas. Often generated automatically.

In addition to the 4 levels, **Deployment Views** document how containers map to physical or cloud infrastructure nodes across environments (**Development** vs. **Production**).

---

## 📝 Structurizr DSL Basics

Structurizr DSL (`workspace.dsl`) is a human-readable text language to define C4 models that compile into PNG, SVG, or interactive diagrams.

### Basic Syntax

```dsl
workspace "System Name" "Description" {
    model {
        # 1. People / Actors
        user = person "User" "End user of the application" "Person"

        # 2. Software Systems
        mySystem = softwareSystem "My System" "Provides core service" "Brand" {
            web = container "Web App" "User interface" "Next.js, React" "WebBrowser"
            api = container "Backend API" "Business logic" "NestJS" "Backend"
            db = container "Database" "Relational storage" "PostgreSQL" "Database"

            user -> web "Uses"
            web -> api "Makes API calls to" "JSON/HTTPS"
            api -> db "Reads and writes to" "Prisma/TCP"
        }

        # 3. External Integrations
        emailProvider = softwareSystem "Email Service" "Transactional email delivery" "External"
        api -> emailProvider "Sends emails using" "REST"
    }

    views {
        systemContext mySystem "SystemContext" "High-level overview" {
            include *
            autoLayout lr
        }

        container mySystem "Containers" "Container breakdown" {
            include *
            autoLayout lr
        }
    }
}
```

---

## 🛠️ How to Render & Export Diagrams

You can render `workspace.dsl` using Docker with the official Structurizr CLI:

```bash
# Export views as PNG images
docker run --rm -v ${PWD}/docs/architecture:/usr/local/structurizr structurizr/cli export -w workspace.dsl -format plantuml
```

Or run the Structurizr Lite interactive web viewer locally:

```bash
docker run -it --rm -p 8080:8080 -v ${PWD}/docs/architecture:/usr/local/structurizr structurizr/lite
```

Then navigate to `http://localhost:8080` in your browser.

---

## 🔗 Related Resources

- Starter Template: [C4 Structurizr Workspace Template](../templates/architecture/c4-workspace-template.dsl)
