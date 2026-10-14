workspace "[Project Name]" "[Short description of the system and its primary purpose]" {
    
    model {
        # =====================================================================
        # 1. Actors / People
        # =====================================================================
        user = person "Primary User" "A standard user interacting with the platform to achieve their core goals." "Person"
        admin = person "System Administrator" "An administrative user managing settings, permissions, and oversight." "Person"
        
        # =====================================================================
        # 2. Core Software System & Containers
        # =====================================================================
        appSystem = softwareSystem "[Project Name] System" "Provides core functionality, data processing, and user interfaces." "Brand" {
            webApp = container "Web Application" "Delivers the responsive user interface for users and administrators." "Next.js, React, Tailwind CSS" "WebBrowser"
            api = container "Backend API" "Handles business logic, authentication, domain rules, and data access." "NestJS, TypeScript" "Backend"
            database = container "Database" "Stores relational domain data, user credentials, and audit logs." "PostgreSQL" "Database"
            storage = container "Object Storage" "Stores uploaded files, media attachments, and assets." "AWS S3 / Cloudflare R2" "BlobStorage"
            
            # Relationships inside the System
            user -> webApp "Interacts with features, views data, and submits forms using"
            admin -> webApp "Configures platform, manages users, and monitors metrics using"
            
            webApp -> api "Makes authenticated REST / GraphQL / WebSocket calls to" "JSON/HTTPS/WSS"
            api -> database "Reads from and writes persistent data to" "Prisma ORM / TCP:5432"
            api -> storage "Uploads and retrieves object files from" "HTTPS"
        }
        
        # =====================================================================
        # 3. External Systems & 3rd-Party Integrations
        # =====================================================================
        emailService = softwareSystem "Email Delivery Provider" "Transactional email provider for verification and notifications (e.g. Resend, SES)." "External"
        api -> emailService "Dispatches transactional emails via" "HTTPS / REST"
        
        # =====================================================================
        # 4. Deployment Environments
        # =====================================================================
        development = deploymentEnvironment "Development" {
            deploymentNode "Developer Workstation" "Windows / macOS / Linux" "Developer Machine" {
                deploymentNode "Node.js Local Runtime" "Executes Next.js web application" "Node.js" {
                    devWebAppInstance = containerInstance webApp
                }
                deploymentNode "Docker Compose Engine" "Local container orchestration" "Docker Engine" {
                    devApiInstance = containerInstance api
                    devDatabaseInstance = containerInstance database
                }
            }
        }
        
        production = deploymentEnvironment "Production" {
            deploymentNode "Vercel / Cloudflare" "Edge Network & Serverless Platform" "Vercel Platform" {
                prodWebAppInstance = containerInstance webApp
            }
            
            deploymentNode "Cloud Provider (AWS)" "Cloud Infrastructure Platform" "AWS Cloud" {
                alb = infrastructureNode "Application Load Balancer" "Routes external HTTPS traffic to API containers." "AWS ALB"
                
                deploymentNode "Container Cluster" "Serverless Container Execution" "AWS ECS Fargate" {
                    deploymentNode "api-service" "Docker container running NestJS" "Docker" {
                        prodApiInstance = containerInstance api
                    }
                }
                
                deploymentNode "Managed Relational Database" "High-Availability DB in private subnet" "AWS RDS PostgreSQL" {
                    prodDatabaseInstance = containerInstance database
                }
                
                deploymentNode "Managed Object Storage" "Scalable blob storage" "AWS S3" {
                    prodStorageInstance = containerInstance storage
                }
                
                prodWebAppInstance -> alb "Makes API requests via" "HTTPS"
                alb -> prodApiInstance "Forwards incoming traffic to" "HTTP:3000"
                prodApiInstance -> prodDatabaseInstance "Queries and persists data to" "Prisma/TCP"
                prodApiInstance -> prodStorageInstance "Uploads/downloads files to" "HTTPS"
            }
        }
    }
    
    views {
        systemContext appSystem "SystemContext" "The system context diagram for [Project Name]." {
            include *
            autoLayout lr
        }
        
        container appSystem "Containers" "The container diagram for [Project Name]." {
            include *
            autoLayout lr
        }
        
        deployment appSystem development "DevelopmentDeployment" "Local development setup using Docker Compose and Node.js." {
            include *
            autoLayout lr
        }
        
        deployment appSystem production "ProductionDeployment" "Production architecture deployed across Vercel and AWS." {
            include *
            autoLayout lr
        }
        
        styles {
            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }
            element "Brand" {
                background #1168bd
                color #ffffff
            }
            element "WebBrowser" {
                shape WebBrowser
                background #225588
                color #ffffff
            }
            element "Backend" {
                shape RoundedBox
                background #2b78e4
                color #ffffff
            }
            element "Database" {
                shape Cylinder
                background #2b78e4
                color #ffffff
            }
            element "BlobStorage" {
                shape Folder
                background #557799
                color #ffffff
            }
            element "External" {
                background #999999
                color #ffffff
            }
        }
    }
}

