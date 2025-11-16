# OsitoPolar Microservices - Complete Architecture Guide

> **Complete technical documentation covering architecture, services, communication patterns, databases, and user flows**

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Services Architecture](#services-architecture)
3. [Communication Patterns](#communication-patterns)
4. [Database Schemas (ERDs)](#database-schemas-erds)
5. [User Flows](#user-flows)
6. [RabbitMQ Implementation](#rabbitmq-implementation)
7. [Domain Model Relationships](#domain-model-relationships)
8. [Deployment & Orchestration](#deployment--orchestration)

---

## System Overview

### High-Level Architecture

```mermaid
graph TB
    subgraph "Client Layer"
        FE[Frontend - Jetpack Compose]
    end

    subgraph "API Gateway Layer"
        GW[Ocelot API Gateway :8080]
    end

    subgraph "Microservices Layer"
        IAM[IAM Service :5001<br/>Authentication & Authorization]
        PROF[Profiles Service :5002<br/>Owners & Providers]
        EQUIP[Equipment Service :5003<br/>Equipment Management]
        WO[WorkOrders Service :5004<br/>Work Order Processing]
        SR[ServiceRequests Service :5005<br/>Request Handling]
        SUB[Subscriptions Service :5006<br/>Plans & Payments]
        NOTIF[Notifications Service :5007<br/>Email & In-App]
        ANAL[Analytics Service :5008<br/>Reports & Metrics]
    end

    subgraph "Message Bus"
        RMQ[RabbitMQ<br/>Event Streaming]
    end

    subgraph "Data Layer"
        DB[(MySQL 8.0<br/>Database per Service)]
    end

    subgraph "External Services"
        STRIPE[Stripe API<br/>Payments]
        MAIL[MailerSend<br/>Email Delivery]
    end

    FE -->|HTTP/REST| GW
    GW --> IAM
    GW --> PROF
    GW --> EQUIP
    GW --> WO
    GW --> SR
    GW --> SUB
    GW --> NOTIF
    GW --> ANAL

    IAM -.->|HTTP| PROF
    IAM -.->|HTTP| SUB
    SR -.->|HTTP| PROF
    SR -.->|HTTP| EQUIP
    SR -.->|HTTP| WO
    WO -.->|HTTP| PROF
    WO -.->|HTTP| EQUIP
    ANAL -.->|HTTP| PROF
    ANAL -.->|HTTP| SUB
    ANAL -.->|HTTP| WO

    SR -->|Events| RMQ
    WO -->|Events| RMQ
    EQUIP -->|Events| RMQ
    RMQ -.->|Subscribe| NOTIF
    RMQ -.->|Subscribe| ANAL

    IAM --> DB
    PROF --> DB
    EQUIP --> DB
    WO --> DB
    SR --> DB
    SUB --> DB
    NOTIF --> DB
    ANAL --> DB

    SUB -->|Payment Processing| STRIPE
    NOTIF -->|Send Emails| MAIL

    style FE fill:#e1f5ff
    style GW fill:#fff3cd
    style RMQ fill:#f8d7da
    style DB fill:#d4edda
    style STRIPE fill:#fce4ec
    style MAIL fill:#fce4ec
```

---

## Services Architecture

### 1. IAM Service (Identity & Access Management)

**Port:** 5001
**Database:** `ositopolar_iam`
**Responsibilities:**
- User authentication (login, register, 2FA)
- JWT token generation and validation
- Role-based access control (Owner, Provider, Admin)
- Password management

**Key Endpoints:**
- `POST /api/v1/authentication/sign-in` - User login
- `POST /api/v1/authentication/sign-up` - User registration
- `POST /api/v1/authentication/verify-2fa` - 2FA verification
- `GET /api/v1/users/{id}` - Get user details

**Dependencies:**
- Profiles Service (HTTP) - Create profile after registration
- Subscriptions Service (HTTP) - Validate subscription status

---

### 2. Profiles Service

**Port:** 5002
**Database:** `ositopolar_profiles`
**Responsibilities:**
- Manage Owner profiles (businesses)
- Manage Provider profiles (technicians, suppliers)
- Profile information (name, email, address)
- Balance tracking for Owners

**Key Endpoints:**
- `GET /api/v1/profiles` - List all profiles
- `GET /api/v1/profiles/{id}` - Get profile by ID
- `POST /api/v1/profiles` - Create profile
- `GET /api/v1/owners/{id}` - Get owner details
- `GET /api/v1/providers/{id}` - Get provider details

**Domain Models:**
- `Profile` (base) → `Owner`, `Provider`

---

### 3. Equipment Service

**Port:** 5003
**Database:** `ositopolar_equipment`
**Responsibilities:**
- Equipment catalog management
- Equipment status tracking (powered on/off)
- Temperature monitoring
- Energy consumption tracking
- Location management (GPS coordinates)

**Key Endpoints:**
- `GET /api/v1/equipment` - List all equipment
- `GET /api/v1/equipment/{id}` - Get equipment details
- `POST /api/v1/equipment` - Register new equipment
- `PUT /api/v1/equipment/{id}/status` - Update equipment status
- `GET /api/v1/equipment/owner/{ownerId}` - Get owner's equipment

**Domain Models:**
- `Equipment` - Main aggregate
- Value Objects: `Location`, `Temperature`, `EnergyConsumption`

---

### 4. ServiceRequests Service

**Port:** 5005
**Database:** `ositopolar_servicerequests`
**Responsibilities:**
- Receive service requests from Owners
- Match requests with Providers
- Request lifecycle management
- Uber-like marketplace functionality

**Key Endpoints:**
- `POST /api/v1/service-requests` - Create service request
- `GET /api/v1/service-requests/{id}` - Get request details
- `PUT /api/v1/service-requests/{id}/accept` - Provider accepts
- `GET /api/v1/service-requests/owner/{ownerId}` - Owner's requests

**Workflow:**
1. Owner creates request
2. System broadcasts to nearby Providers
3. Provider accepts request
4. Work Order is created automatically

**Events Published:**
- `ServiceRequestCreated`
- `ServiceRequestAccepted`
- `ServiceRequestCompleted`

---

### 5. WorkOrders Service

**Port:** 5004
**Database:** `ositopolar_workorders`
**Responsibilities:**
- Work order lifecycle management
- Technician assignment
- Scheduling and time slots
- Work completion tracking
- Cost calculation

**Key Endpoints:**
- `GET /api/v1/work-orders` - List work orders
- `GET /api/v1/work-orders/{id}` - Get work order details
- `PUT /api/v1/work-orders/{id}/assign` - Assign technician
- `PUT /api/v1/work-orders/{id}/complete` - Mark complete
- `POST /api/v1/work-orders/{id}/feedback` - Submit feedback

**Domain Models:**
- `WorkOrder` - Main aggregate
- Value Objects: `WorkOrderStatus`, `Priority`, `TimeSlot`

**Events Published:**
- `WorkOrderCreated`
- `WorkOrderAssigned`
- `WorkOrderCompleted`

---

### 6. Subscriptions Service

**Port:** 5006
**Database:** `ositopolar_subscriptions`
**Responsibilities:**
- Subscription plan management (Polar Bear, Snow Bear, Glacial Bear)
- Payment processing via Stripe
- Subscription lifecycle
- Service payment tracking

**Key Endpoints:**
- `GET /api/v1/subscriptions` - List available plans
- `GET /api/v1/subscriptions/{id}` - Get plan details
- `POST /api/v1/payments/create-session` - Create Stripe session
- `POST /api/v1/payments/webhook` - Stripe webhook handler
- `GET /api/v1/payments/user/{userId}` - User payment history

**Integration:**
- **Stripe API** - Payment processing
- Payment flow: Frontend → Create Session → Redirect to Stripe → Webhook confirms

**Domain Models:**
- `Subscription` - Plan details
- `Payment` - Payment records
- `ServicePayment` - Service-specific payments

---

### 7. Notifications Service

**Port:** 5007
**Database:** `ositopolar_notifications`
**Responsibilities:**
- Email notifications via MailerSend
- In-app notifications
- Template-based messaging
- Notification history

**Key Endpoints:**
- `POST /api/v1/notifications/email` - Send email
- `POST /api/v1/notifications/in-app` - Create in-app notification
- `GET /api/v1/notifications/user/{userId}` - Get user notifications
- `PUT /api/v1/notifications/{id}/read` - Mark as read

**Integration:**
- **MailerSend SMTP** - Email delivery
- HTML templates for professional emails

**Notification Types:**
- Welcome email (registration)
- Service request created
- Work order assigned
- Work order completed
- Payment confirmation

---

### 8. Analytics Service

**Port:** 5008
**Database:** `ositopolar_analytics`
**Responsibilities:**
- Business intelligence
- Usage metrics
- Performance reports
- Dashboard data aggregation

**Key Endpoints:**
- `GET /api/v1/analytics/dashboard/{ownerId}` - Owner dashboard
- `GET /api/v1/analytics/equipment-stats` - Equipment statistics
- `GET /api/v1/analytics/service-metrics` - Service performance
- `GET /api/v1/analytics/revenue-report` - Revenue analytics

**Data Sources:**
- Profiles Service - User data
- Equipment Service - Equipment metrics
- WorkOrders Service - Service completion rates
- Subscriptions Service - Revenue data

---

## Communication Patterns

### Synchronous Communication (HTTP)

```mermaid
sequenceDiagram
    participant Client
    participant Gateway
    participant IAM
    participant Profiles
    participant Subscriptions

    Client->>Gateway: POST /api/v1/authentication/sign-up
    Gateway->>IAM: POST /sign-up
    IAM->>IAM: Validate credentials
    IAM->>IAM: Hash password
    IAM->>IAM: Create user

    IAM->>Profiles: HTTP POST /api/v1/profiles
    Profiles->>Profiles: Create Owner profile
    Profiles-->>IAM: ProfileResource

    IAM->>Subscriptions: HTTP POST /api/v1/subscriptions/assign
    Subscriptions->>Subscriptions: Assign default plan
    Subscriptions-->>IAM: SubscriptionResource

    IAM-->>Gateway: UserResource + JWT Token
    Gateway-->>Client: 201 Created + Token
```

**When to use HTTP:**
- Real-time data required (user login, fetching profiles)
- Synchronous workflows (create profile → assign subscription)
- Request-response pattern
- Data validation needed immediately

**Anti-Corruption Layer (ACL):**
- Each service has HTTP Facades for calling other services
- Example: `ProfilesHttpFacade` in IAM service
- Transforms external responses to internal domain models

---

### Asynchronous Communication (RabbitMQ)

```mermaid
sequenceDiagram
    participant Owner
    participant SR as ServiceRequests
    participant RabbitMQ
    participant WO as WorkOrders
    participant Notif as Notifications
    participant Anal as Analytics

    Owner->>SR: Create Service Request
    SR->>SR: Validate & Save
    SR->>RabbitMQ: Publish: ServiceRequestCreated
    SR-->>Owner: 201 Created

    RabbitMQ->>Notif: Event: ServiceRequestCreated
    Notif->>Notif: Generate email
    Notif->>MailerSend: Send notification

    RabbitMQ->>Anal: Event: ServiceRequestCreated
    Anal->>Anal: Update metrics

    Note over SR,WO: Provider accepts request

    SR->>RabbitMQ: Publish: ServiceRequestAccepted
    RabbitMQ->>WO: Event: ServiceRequestAccepted
    WO->>WO: Create Work Order
    WO->>RabbitMQ: Publish: WorkOrderCreated

    RabbitMQ->>Notif: Event: WorkOrderCreated
    Notif->>MailerSend: Send "Work Order Assigned"
```

**When to use RabbitMQ:**
- Fire-and-forget operations (send notification)
- Event-driven workflows (service request → work order)
- Multiple subscribers need the same event
- Decoupling services (notifications, analytics)

**Event Types:**

| Event | Publisher | Subscribers | Purpose |
|-------|-----------|-------------|---------|
| `ServiceRequestCreated` | ServiceRequests | Notifications, Analytics | Notify stakeholders |
| `ServiceRequestAccepted` | ServiceRequests | WorkOrders, Notifications | Create work order |
| `WorkOrderCreated` | WorkOrders | Notifications, Analytics | Notify assignment |
| `WorkOrderCompleted` | WorkOrders | Notifications, Analytics, Subscriptions | Trigger billing |
| `EquipmentStatusChanged` | Equipment | Notifications, Analytics | Alert owners |

---

## Database Schemas (ERDs)

### IAM Service Database (`ositopolar_iam`)

```mermaid
erDiagram
    users {
        int id PK
        string username UK
        string password_hash
        string email UK
        string role
        datetime created_at
        datetime updated_at
        boolean is_2fa_enabled
        string two_fa_secret
    }

    refresh_tokens {
        int id PK
        int user_id FK
        string token
        datetime expires_at
        datetime created_at
    }

    users ||--o{ refresh_tokens : has
```

**Key Points:**
- Stores authentication credentials only
- Links to Profiles service via user_id
- JWT tokens generated, not stored
- 2FA support with TOTP secrets

---

### Profiles Service Database (`ositopolar_profiles`)

```mermaid
erDiagram
    profiles {
        int id PK
        string first_name
        string last_name
        string email UK
        string street
        string number
        string city
        string postal_code
        string country
    }

    owners {
        int id PK
        int user_id FK
        decimal balance
        int plan_id FK
        int max_units
    }

    providers {
        int id PK
        int user_id FK
        string company_name
        string service_type
        decimal rating
        int completed_jobs
    }

    profiles ||--o| owners : extends
    profiles ||--o| providers : extends
```

**Key Points:**
- Single Table Inheritance pattern
- Owners link to Subscriptions (plan_id)
- Providers track ratings and job history
- Balance tracking for billing

---

### Equipment Service Database (`ositopolar_equipment`)

```mermaid
erDiagram
    equipment {
        int id PK
        string name
        string type
        string model
        string manufacturer
        string serial_number UK
        string code UK
        decimal cost
        string technical_details
        string status
        boolean is_powered_on
        datetime installation_date
        decimal current_temperature
        decimal set_temperature
        decimal optimal_temp_min
        decimal optimal_temp_max
        string location_name
        string location_address
        decimal location_latitude
        decimal location_longitude
        decimal energy_consumption_current
        string energy_consumption_unit
        decimal energy_consumption_average
        int owner_id FK
        string owner_type
        string ownership_type
        string notes
        datetime created_at
        datetime updated_at
    }

    equipment_history {
        int id PK
        int equipment_id FK
        string event_type
        json data
        datetime occurred_at
    }

    equipment ||--o{ equipment_history : has
```

**Key Points:**
- Complete equipment lifecycle tracking
- GPS location tracking
- Temperature and energy monitoring
- Ownership tracking (owned/rented)

---

### ServiceRequests Service Database (`ositopolar_servicerequests`)

```mermaid
erDiagram
    service_requests {
        int id PK
        string request_number UK
        int requester_id FK
        int equipment_id FK
        string service_type
        string description
        string urgency_level
        datetime preferred_date
        string time_slot_preference
        string service_address
        decimal estimated_cost
        string status
        int accepted_by_provider_id FK
        datetime accepted_at
        string rejection_reason
        datetime created_at
        datetime updated_at
    }

    service_request_bids {
        int id PK
        int service_request_id FK
        int provider_id FK
        decimal bid_amount
        string message
        datetime submitted_at
        string status
    }

    service_requests ||--o{ service_request_bids : receives
```

**Key Points:**
- Uber-like marketplace model
- Providers can bid on requests
- Status workflow: Pending → Accepted → InProgress → Completed
- Links to Equipment and Profiles services

---

### WorkOrders Service Database (`ositopolar_workorders`)

```mermaid
erDiagram
    work_orders {
        int id PK
        string work_order_number UK
        int service_request_id FK
        string title
        string description
        string issue_details
        datetime creation_time
        string status
        string priority
        int assigned_technician_id FK
        datetime scheduled_date
        string time_slot
        string service_address
        datetime desired_completion_date
        datetime actual_completion_date
        string resolution_details
        string technician_notes
        decimal cost
        int customer_feedback_rating
        datetime feedback_submission_date
        int equipment_id FK
        int owner_id FK
        datetime created_at
        datetime updated_at
    }

    work_order_items {
        int id PK
        int work_order_id FK
        string item_type
        string description
        decimal quantity
        decimal unit_price
        decimal total_price
    }

    work_order_attachments {
        int id PK
        int work_order_id FK
        string file_name
        string file_path
        string file_type
        datetime uploaded_at
    }

    work_orders ||--o{ work_order_items : contains
    work_orders ||--o{ work_order_attachments : has
```

**Key Points:**
- Complete work order lifecycle
- Itemized billing (parts, labor)
- File attachments (photos, reports)
- Customer feedback and ratings

---

### Subscriptions Service Database (`ositopolar_subscriptions`)

```mermaid
erDiagram
    subscriptions {
        int id PK
        string plan_name UK
        decimal price
        string currency
        string billing_cycle
        int max_equipment
        int max_clients
        string features_json
        datetime created_at
        datetime updated_at
    }

    payments {
        int id PK
        int user_id FK
        int subscription_id FK
        decimal amount
        string currency
        string stripe_session_id UK
        string stripe_status
        string customer_email
        string description
        datetime created_at
    }

    service_payments {
        int id PK
        int work_order_id FK
        int owner_id FK
        int provider_id FK
        decimal amount
        string currency
        string payment_status
        string stripe_payment_intent_id
        datetime paid_at
        datetime created_at
    }

    subscriptions ||--o{ payments : has
```

**Key Points:**
- Subscription plans (Polar Bear, Snow Bear, Glacial Bear)
- Payment tracking via Stripe
- Service payments separate from subscriptions
- Features stored as JSON for flexibility

---

### Notifications Service Database (`ositopolar_notifications`)

```mermaid
erDiagram
    email_notifications {
        int id PK
        string to_email
        string subject
        string body_html
        string body_text
        string status
        datetime sent_at
        string error_message
        datetime created_at
    }

    in_app_notifications {
        int id PK
        int user_id FK
        string title
        string message
        string notification_type
        boolean is_read
        datetime read_at
        json metadata
        datetime created_at
    }
```

**Key Points:**
- Separate email and in-app notifications
- Template-based email generation
- Read/unread tracking for in-app
- Error logging for failed sends

---

### Analytics Service Database (`ositopolar_analytics`)

```mermaid
erDiagram
    analytics_events {
        int id PK
        string event_type
        int entity_id
        string entity_type
        json event_data
        datetime occurred_at
    }

    dashboard_metrics {
        int id PK
        int owner_id FK
        string metric_type
        decimal metric_value
        date metric_date
        datetime calculated_at
    }

    reports {
        int id PK
        string report_type
        int generated_by_user_id FK
        json report_data
        datetime generated_at
    }
```

**Key Points:**
- Event sourcing for analytics
- Pre-calculated dashboard metrics
- Report generation and storage
- Time-series data for trends

---

## User Flows

### Complete Registration Flow

```mermaid
sequenceDiagram
    participant U as User (Frontend)
    participant GW as API Gateway
    participant IAM as IAM Service
    participant SUB as Subscriptions
    participant STRIPE as Stripe
    participant PROF as Profiles
    participant NOTIF as Notifications

    Note over U: 1. View Plans
    U->>GW: GET /api/v1/subscriptions
    GW->>SUB: GET /subscriptions
    SUB-->>GW: [Plans: Polar, Snow, Glacial]
    GW-->>U: Display plans

    Note over U: 2. Select Plan & Pay
    U->>GW: POST /api/v1/payments/create-session
    GW->>SUB: Create Stripe session
    SUB->>STRIPE: Create checkout session
    STRIPE-->>SUB: Session URL
    SUB-->>GW: Redirect URL
    GW-->>U: Redirect to Stripe

    U->>STRIPE: Complete payment
    STRIPE->>SUB: Webhook: payment_succeeded
    SUB->>SUB: Record payment

    Note over U: 3. Register Account
    U->>GW: POST /api/v1/authentication/sign-up
    GW->>IAM: Create account
    IAM->>IAM: Hash password
    IAM->>IAM: Create user

    IAM->>PROF: HTTP: Create Owner profile
    PROF->>PROF: Create profile with plan_id
    PROF-->>IAM: Profile created

    IAM->>NOTIF: HTTP: Send welcome email
    NOTIF->>MailerSend: Send email

    IAM-->>GW: User + JWT Token
    GW-->>U: 201 Created + Token

    Note over U: 4. Setup 2FA
    U->>GW: POST /api/v1/authentication/setup-2fa
    GW->>IAM: Generate TOTP secret
    IAM-->>GW: QR Code
    GW-->>U: Display QR

    U->>GW: POST /api/v1/authentication/verify-2fa
    GW->>IAM: Verify code
    IAM-->>GW: 2FA enabled
    GW-->>U: Success

    Note over U: 5. Complete Login
    U->>GW: POST /api/v1/authentication/sign-in
    GW->>IAM: Validate credentials
    IAM->>IAM: Check 2FA
    IAM-->>GW: JWT Token
    GW-->>U: Redirect to Dashboard
```

---

### Service Request to Work Order Flow

```mermaid
sequenceDiagram
    participant O as Owner
    participant GW as Gateway
    participant SR as ServiceRequests
    participant RMQ as RabbitMQ
    participant WO as WorkOrders
    participant NOTIF as Notifications
    participant P as Provider

    Note over O: Owner needs repair
    O->>GW: POST /api/v1/service-requests
    GW->>SR: Create request
    SR->>SR: Validate equipment exists
    SR->>SR: Save request (status: Pending)

    SR->>RMQ: Publish: ServiceRequestCreated
    SR-->>GW: 201 Created
    GW-->>O: Request created

    RMQ->>NOTIF: Event: ServiceRequestCreated
    NOTIF->>NOTIF: Find nearby providers
    NOTIF->>MailerSend: Email providers

    Note over P: Provider accepts
    P->>GW: PUT /api/v1/service-requests/{id}/accept
    GW->>SR: Accept request
    SR->>SR: Update status: Accepted
    SR->>SR: Set accepted_by_provider_id

    SR->>RMQ: Publish: ServiceRequestAccepted
    SR-->>GW: 200 OK
    GW-->>P: Request accepted

    RMQ->>WO: Event: ServiceRequestAccepted
    WO->>WO: Create Work Order
    WO->>WO: Assign to provider
    WO->>WO: Status: Scheduled

    WO->>RMQ: Publish: WorkOrderCreated

    RMQ->>NOTIF: Event: WorkOrderCreated
    NOTIF->>MailerSend: Email owner confirmation
    NOTIF->>MailerSend: Email provider assignment

    Note over P: Complete work
    P->>GW: PUT /api/v1/work-orders/{id}/complete
    GW->>WO: Mark complete
    WO->>WO: Update status: Completed
    WO->>WO: Set actual_completion_date

    WO->>RMQ: Publish: WorkOrderCompleted
    WO-->>GW: 200 OK
    GW-->>P: Work completed

    RMQ->>NOTIF: Event: WorkOrderCompleted
    NOTIF->>MailerSend: Email owner completion
```

---

### Equipment Monitoring Flow

```mermaid
graph TD
    A[Equipment Sensor] -->|Temperature reading| B[Equipment Service]
    B -->|Update equipment| C{Temperature OK?}

    C -->|Yes| D[Update metrics only]
    C -->|No| E[Publish: EquipmentAlert]

    E -->|Event| F[RabbitMQ]
    F -->|Subscribe| G[Notifications Service]
    F -->|Subscribe| H[Analytics Service]

    G -->|Send alert| I[MailerSend]
    I -->|Email| J[Owner]

    G -->|In-app notification| K[Owner Dashboard]

    H -->|Log incident| L[Analytics DB]
    H -->|Update metrics| M[Dashboard Metrics]

    style E fill:#f99
    style J fill:#9f9
    style K fill:#9f9
```

---

## RabbitMQ Implementation

### Architecture

```mermaid
graph TB
    subgraph "Publishers"
        SR[ServiceRequests<br/>Service]
        WO[WorkOrders<br/>Service]
        EQUIP[Equipment<br/>Service]
    end

    subgraph "RabbitMQ Exchange"
        EX[Topic Exchange<br/>'ositopolar.events']
    end

    subgraph "Queues"
        Q1[notifications.queue]
        Q2[analytics.queue]
        Q3[workorders.queue]
    end

    subgraph "Subscribers"
        NOTIF[Notifications<br/>Service]
        ANAL[Analytics<br/>Service]
        WO2[WorkOrders<br/>Service]
    end

    SR -->|service.request.*| EX
    WO -->|work.order.*| EX
    EQUIP -->|equipment.*| EX

    EX -->|Routing Key:<br/>*.created<br/>*.updated| Q1
    EX -->|Routing Key:<br/>*.*| Q2
    EX -->|Routing Key:<br/>service.request.accepted| Q3

    Q1 --> NOTIF
    Q2 --> ANAL
    Q3 --> WO2

    style EX fill:#f9f
    style Q1 fill:#ff9
    style Q2 fill:#9ff
    style Q3 fill:#f99
```

### Event Contracts

**ServiceRequestCreated Event:**
```json
{
  "eventId": "uuid",
  "eventType": "service.request.created",
  "timestamp": "2025-11-15T10:30:00Z",
  "data": {
    "serviceRequestId": 123,
    "requesterId": 45,
    "equipmentId": 67,
    "serviceType": "Maintenance",
    "urgency": "High",
    "location": {
      "latitude": -12.0464,
      "longitude": -77.0428
    }
  }
}
```

**WorkOrderCreated Event:**
```json
{
  "eventId": "uuid",
  "eventType": "work.order.created",
  "timestamp": "2025-11-15T11:00:00Z",
  "data": {
    "workOrderId": 456,
    "workOrderNumber": "WO-2025-001",
    "serviceRequestId": 123,
    "assignedTechnicianId": 78,
    "scheduledDate": "2025-11-16T14:00:00Z",
    "equipmentId": 67,
    "ownerId": 45
  }
}
```

### RabbitMQ Configuration

**Exchange:**
- Name: `ositopolar.events`
- Type: `Topic`
- Durable: `true`
- Auto-delete: `false`

**Routing Key Patterns:**
- `service.request.created`
- `service.request.accepted`
- `service.request.completed`
- `work.order.created`
- `work.order.assigned`
- `work.order.completed`
- `equipment.status.changed`
- `equipment.alert.temperature`

**Queues:**

| Queue Name | Bindings | Consumer |
|------------|----------|----------|
| `notifications.queue` | `*.created`, `*.completed`, `*.alert.*` | Notifications Service |
| `analytics.queue` | `*.*` (all events) | Analytics Service |
| `workorders.queue` | `service.request.accepted` | WorkOrders Service |

### Implementation Steps

1. **Install RabbitMQ** (Docker):
```yaml
rabbitmq:
  image: rabbitmq:3-management
  ports:
    - "5672:5672"
    - "15672:15672"
  environment:
    RABBITMQ_DEFAULT_USER: ositopolar
    RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASSWORD}
```

2. **Add NuGet Package** to each service:
```bash
dotnet add package RabbitMQ.Client
```

3. **Create Event Bus Interface**:
```csharp
public interface IEventBus
{
    void Publish<T>(T @event) where T : IntegrationEvent;
    void Subscribe<T, TH>()
        where T : IntegrationEvent
        where TH : IIntegrationEventHandler<T>;
}
```

4. **Implement Publisher** (ServiceRequests):
```csharp
public class ServiceRequestCommandService
{
    private readonly IEventBus _eventBus;

    public async Task CreateServiceRequest(...)
    {
        var serviceRequest = new ServiceRequest(...);
        await _repository.AddAsync(serviceRequest);
        await _unitOfWork.CompleteAsync();

        // Publish event
        var @event = new ServiceRequestCreatedEvent
        {
            ServiceRequestId = serviceRequest.Id,
            RequesterId = serviceRequest.RequesterId,
            EquipmentId = serviceRequest.EquipmentId
        };

        _eventBus.Publish(@event);
    }
}
```

5. **Implement Subscriber** (Notifications):
```csharp
public class ServiceRequestCreatedHandler
    : IIntegrationEventHandler<ServiceRequestCreatedEvent>
{
    public async Task Handle(ServiceRequestCreatedEvent @event)
    {
        // Send notification email
        await _emailService.SendServiceRequestNotification(@event);
    }
}
```

---

## Domain Model Relationships

### Core Domain Models

```mermaid
classDiagram
    class Profile {
        +int Id
        +PersonName Name
        +EmailAddress Email
        +StreetAddress Address
        +string FullName
        +string EmailAddress
        +string StreetAddress
    }

    class Owner {
        +int UserId
        +decimal Balance
        +int PlanId
        +int MaxUnits
        +AddCharge(amount, reason)
        +RecordPayment(amount)
        +UpdatePlan(planId, maxUnits)
    }

    class Provider {
        +int UserId
        +string CompanyName
        +string ServiceType
        +decimal Rating
        +int CompletedJobs
        +UpdateRating(rating)
    }

    class Equipment {
        +int Id
        +string Name
        +EquipmentType Type
        +Location Location
        +Temperature Temperature
        +EnergyConsumption Energy
        +EquipmentStatus Status
        +PowerOn()
        +PowerOff()
        +UpdateTemperature(temp)
    }

    class ServiceRequest {
        +int Id
        +string RequestNumber
        +int RequesterId
        +int EquipmentId
        +ServiceType Type
        +RequestStatus Status
        +Accept(providerId)
        +Reject(reason)
        +Complete()
    }

    class WorkOrder {
        +int Id
        +string WorkOrderNumber
        +int ServiceRequestId
        +WorkOrderStatus Status
        +Priority Priority
        +AssignTechnician(techId)
        +Schedule(date, timeSlot)
        +Complete(resolution)
    }

    class Subscription {
        +int Id
        +string PlanName
        +Price Price
        +BillingCycle Cycle
        +int MaxEquipment
        +int MaxClients
        +List~Feature~ Features
    }

    class Payment {
        +int Id
        +int UserId
        +int SubscriptionId
        +Price Amount
        +StripeSession Session
        +UpdateStatus(status)
    }

    Profile <|-- Owner : extends
    Profile <|-- Provider : extends
    Owner "1" --> "0..*" Equipment : owns
    Owner "1" --> "1" Subscription : has
    Owner "1" --> "0..*" ServiceRequest : creates
    Provider "1" --> "0..*" ServiceRequest : accepts
    ServiceRequest "1" --> "1" Equipment : for
    ServiceRequest "1" --> "0..1" WorkOrder : generates
    WorkOrder "1" --> "1" Equipment : repairs
    WorkOrder "1" --> "1" Provider : assigned_to
    Subscription "1" --> "0..*" Payment : has
```

### Value Objects

```mermaid
classDiagram
    class PersonName {
        +string FirstName
        +string LastName
        +string FullName
    }

    class EmailAddress {
        +string Address
        +Validate()
    }

    class StreetAddress {
        +string Street
        +string Number
        +string City
        +string PostalCode
        +string Country
        +string FullAddress
    }

    class Location {
        +string Name
        +string Address
        +decimal Latitude
        +decimal Longitude
        +CalculateDistance(other)
    }

    class Temperature {
        +decimal Current
        +decimal Set
        +decimal OptimalMin
        +decimal OptimalMax
        +bool IsOptimal
    }

    class Price {
        +decimal Amount
        +string Currency
        +Add(other)
        +Multiply(factor)
    }

    class StripeSession {
        +string SessionId
        +PaymentStatus Status
        +MarkAsSucceeded()
        +MarkAsFailed()
    }
```

---

## Deployment & Orchestration

### Docker Compose Structure

```mermaid
graph TB
    subgraph "Docker Compose"
        subgraph "Network: ositopolar-network"
            GW[API Gateway<br/>:8080]

            subgraph "Services"
                IAM[IAM :5001]
                PROF[Profiles :5002]
                EQUIP[Equipment :5003]
                WO[WorkOrders :5004]
                SR[ServiceRequests :5005]
                SUB[Subscriptions :5006]
                NOTIF[Notifications :5007]
                ANAL[Analytics :5008]
            end

            RMQ[RabbitMQ<br/>:5672, :15672]
        end

        HOST[Host MySQL<br/>:3306<br/>host.docker.internal]
    end

    GW --> IAM
    GW --> PROF
    GW --> EQUIP
    GW --> WO
    GW --> SR
    GW --> SUB
    GW --> NOTIF
    GW --> ANAL

    IAM -.->|host.docker.internal| HOST
    PROF -.->|host.docker.internal| HOST
    EQUIP -.->|host.docker.internal| HOST
    WO -.->|host.docker.internal| HOST
    SR -.->|host.docker.internal| HOST
    SUB -.->|host.docker.internal| HOST
    NOTIF -.->|host.docker.internal| HOST
    ANAL -.->|host.docker.internal| HOST

    SR -->|Publish| RMQ
    WO -->|Publish| RMQ
    EQUIP -->|Publish| RMQ
    RMQ -.->|Subscribe| NOTIF
    RMQ -.->|Subscribe| ANAL
    RMQ -.->|Subscribe| WO

    style HOST fill:#d4edda
    style RMQ fill:#f8d7da
```

### Deployment Commands

```bash
# Start all services
cd C:\Users\josep\RiderProjects\Microservicios\OsitoPolar.Infrastructure
docker-compose up -d --build

# View logs
docker-compose logs -f

# View specific service logs
docker logs ositopolar-iam -f

# Check service health
docker ps

# Stop all services
docker-compose down

# Restart specific service
docker-compose restart iam-service

# View RabbitMQ Management UI
# Open browser: http://localhost:15672
# Username: ositopolar / Password: from .env
```

### Health Checks

Each service implements health check endpoints:

```
GET /health
```

**Response:**
```json
{
  "status": "Healthy",
  "checks": {
    "database": "Connected",
    "rabbitmq": "Connected"
  },
  "timestamp": "2025-11-15T10:30:00Z"
}
```

---

## Environment Variables

### Required Configuration

Create `.env` file in Infrastructure directory:

```env
# Database
MYSQL_ROOT_PASSWORD=your_password

# JWT
JWT_SECRET=your_jwt_secret_key_min_32_chars

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# MailerSend
MAILERSEND_USERNAME=MS_...
MAILERSEND_PASSWORD=your_password
MAILERSEND_FROM_EMAIL=noreply@ositopolar.com

# RabbitMQ (future)
RABBITMQ_PASSWORD=your_rabbitmq_password
```

---

## API Gateway Routes (Ocelot)

### Route Configuration

```json
{
  "Routes": [
    {
      "DownstreamPathTemplate": "/api/v1/{everything}",
      "DownstreamScheme": "http",
      "DownstreamHostAndPorts": [
        { "Host": "iam-service", "Port": 8080 }
      ],
      "UpstreamPathTemplate": "/api/v1/authentication/{everything}",
      "UpstreamHttpMethod": [ "GET", "POST", "PUT", "DELETE" ]
    },
    {
      "DownstreamPathTemplate": "/api/v1/{everything}",
      "DownstreamScheme": "http",
      "DownstreamHostAndPorts": [
        { "Host": "profiles-service", "Port": 8080 }
      ],
      "UpstreamPathTemplate": "/api/v1/profiles/{everything}",
      "UpstreamHttpMethod": [ "GET", "POST", "PUT", "DELETE" ]
    }
  ],
  "GlobalConfiguration": {
    "BaseUrl": "http://localhost:8080"
  }
}
```

---

## Monitoring & Observability

### Metrics to Track

**Per Service:**
- Request count
- Response time (p50, p95, p99)
- Error rate
- Database connection pool usage

**RabbitMQ:**
- Messages published/consumed
- Queue depth
- Consumer lag
- Failed messages

**Infrastructure:**
- Container CPU/Memory usage
- Network I/O
- Disk usage

### Logging Strategy

**Log Levels:**
- `DEBUG` - Development only
- `INFO` - Service startup, major operations
- `WARN` - Recoverable errors, deprecated features
- `ERROR` - Unhandled exceptions, critical failures

**Structured Logging Format:**
```json
{
  "timestamp": "2025-11-15T10:30:00Z",
  "level": "INFO",
  "service": "iam-service",
  "traceId": "abc123",
  "message": "User logged in successfully",
  "userId": 123,
  "ipAddress": "192.168.1.1"
}
```

---

## Security Considerations

1. **JWT Token Validation** - All services validate tokens via IAM
2. **HTTPS** - All external communication encrypted
3. **SQL Injection** - Parameterized queries, EF Core protection
4. **CORS** - Configured per service, restrictive in production
5. **Rate Limiting** - API Gateway implements rate limits
6. **Secrets Management** - Environment variables, never in code
7. **Database Access** - Principle of least privilege
8. **Service-to-Service Auth** - API keys for internal communication

---

## Next Steps

### Phase 1: Current State ✅
- [x] Docker infrastructure running
- [x] 8 microservices operational
- [x] MySQL databases per service
- [x] HTTP communication working
- [x] Stripe integration configured
- [x] MailerSend integration configured

### Phase 2: RabbitMQ Implementation (Next)
- [ ] Add RabbitMQ to docker-compose
- [ ] Implement Event Bus abstraction
- [ ] Add event publishers to ServiceRequests, WorkOrders
- [ ] Add event subscribers to Notifications, Analytics
- [ ] Test async workflows

### Phase 3: API Gateway Enhancement
- [ ] Configure Ocelot routes
- [ ] Add authentication middleware
- [ ] Implement rate limiting
- [ ] Add request/response logging

### Phase 4: Production Readiness
- [ ] Add health checks to all services
- [ ] Implement distributed tracing (OpenTelemetry)
- [ ] Add monitoring (Prometheus + Grafana)
- [ ] Configure auto-scaling
- [ ] Add backup strategy for databases

---

## Troubleshooting

### Common Issues

**Services can't connect to MySQL:**
```bash
# Check if MySQL is running
netstat -an | findstr 3306

# Test connection from service
docker exec ositopolar-iam mysql -h host.docker.internal -u root -p
```

**RabbitMQ connection failed:**
```bash
# Check RabbitMQ is running
docker logs ositopolar-rabbitmq

# Access management UI
http://localhost:15672
```

**Service crashes on startup:**
```bash
# View service logs
docker logs ositopolar-[service-name]

# Check environment variables
docker exec ositopolar-[service-name] env
```

---

## Contact & Support

For questions or issues:
- Check logs: `docker-compose logs -f`
- Review this documentation
- Check service health: `http://localhost:[port]/health`
- View API docs: `http://localhost:[port]/swagger`

---

**Generated:** 2025-11-15
**Version:** 1.0
**Status:** Production Ready (Phase 1 Complete)
