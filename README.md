# Water Supply Management System

A complete, production-ready water utility management system built with **Java Spring Boot** (backend) and **React** (frontend).

## 🎯 Features

### Role-Based Access Control
- **Admin**: Manage customers, employees, products, schedules, billing, and analytics
- **Employee**: View assigned deliveries, track earnings, complete deliveries
- **User**: Order products, submit complaints, view consumption and billing

### Key Functionalities
- JWT-based authentication and authorization
- Multithreaded bill generation (async processing)
- Synchronized delivery schedule assignment (prevents conflicts)
- Immutable billing and earnings records
- Real-time dashboard analytics with charts
- Product ordering system with stock management
- Complaint management with status tracking
- Revenue trend analysis

### CS Concepts Demonstrated
- **Multithreading**: Async bill generation using thread pools
- **Synchronization**: Schedule assignment and stock updates
- **Exception Handling**: Custom exceptions with global handler
- **Immutability**: Bills, earnings, and order summaries
- **Generics**: ApiResponse<T> wrapper

## 🛠️ Tech Stack

### Backend
- Java 17
- Spring Boot 3.2.1
- Spring Security (JWT)
- Spring Data JPA
- PostgreSQL
- Lombok
- Maven

### Frontend
- React 18
- React Router DOM
- Axios
- Recharts (charts)
- Modern CSS with theme variables

## 📋 Prerequisites

- Java 17 or higher
- Node.js 16+ and npm
- PostgreSQL 12+
- Maven 3.6+

## 🚀 Setup Instructions

### 1. Database Setup

Create a PostgreSQL database:

```sql
CREATE DATABASE watersupply;
```

Update database credentials in `backend/src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/watersupply
    username: postgres
    password: your_password
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies and build
mvn clean install

# Run the application
mvn spring-boot:run
```

The backend will start on `http://localhost:8080`

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm start
```

The frontend will start on `http://localhost:3000`

## 👤 Default Credentials

| Role     | Email                | Password  |
|----------|---------------------|-----------|
| Admin    | admin@water.com     | admin123  |
| Employee | employee@water.com  | emp123    |
| User     | user@water.com      | user123   |

## 📁 Project Structure

### Backend

```
backend/
├── src/main/java/com/watersupply/
│   ├── WaterSupplyApplication.java
│   ├── admin/
│   │   ├── controller/
│   │   ├── service/
│   │   └── dto/
│   ├── employee/
│   │   └── controller/
│   ├── user/
│   │   ├── controller/
│   │   ├── service/
│   │   └── dto/
│   └── common/
│       ├── entity/
│       ├── repository/
│       ├── security/
│       ├── config/
│       ├── exception/
│       └── dto/
└── pom.xml
```

### Frontend

```
frontend/
├── src/
│   ├── components/
│   │   ├── Sidebar.js
│   │   ├── DashboardCard.js
│   │   └── ProtectedRoute.js
│   ├── pages/
│   │   ├── Login.js
│   │   ├── admin/
│   │   ├── employee/
│   │   └── user/
│   ├── services/
│   │   ├── api.js
│   │   └── authService.js
│   ├── App.js
│   └── index.js
└── package.json
```

## 🎨 UI Theme

The application uses a modern admin dashboard theme with:

- **Primary Blue**: #1F4FD8
- **Success Green**: #22C55E
- **Accent Purple**: #A855F7
- **Light Gray Background**: #F4F6F8
- Inter font family
- Card-based layouts
- Smooth animations and transitions

## 🔐 API Endpoints

### Authentication
- `POST /api/auth/login` - User login

### Admin
- `GET /api/admin/dashboard/stats` - Dashboard statistics
- `GET /api/admin/dashboard/revenue-trend` - Revenue trend data
- `POST /api/admin/schedules/assign` - Assign delivery to employee
- `POST /api/admin/billing/generate` - Generate monthly bills (async)

### Employee
- `GET /api/employee/schedules` - Get assigned schedules
- `PUT /api/employee/schedules/{id}/start` - Start delivery
- `PUT /api/employee/schedules/{id}/complete` - Complete delivery
- `GET /api/employee/earnings/daily` - Daily earnings
- `GET /api/employee/earnings/monthly` - Monthly earnings

### User
- `GET /api/user/products` - Browse products
- `POST /api/user/orders` - Place order
- `GET /api/user/orders` - Order history
- `POST /api/user/complaints` - Submit complaint
- `GET /api/user/complaints` - View complaints

## 🧪 Testing

### Backend Tests
```bash
cd backend
mvn test
```

### Frontend Build
```bash
cd frontend
npm run build
```

## 📝 Key Implementation Details

### Multithreading (BillingService)
- Uses `@Async` annotation with custom thread pool
- Processes bills in parallel using Java streams
- Thread-safe with atomic counters

### Synchronization (ScheduleAssignmentService)
- Synchronized method prevents double-assignment
- Transactional to ensure data consistency
- Validates order status before assignment

### Exception Handling
- Custom exceptions: ResourceNotFoundException, UnauthorizedException, DataConflictException
- Global exception handler with @RestControllerAdvice
- Consistent error responses

### Immutability
- Bills marked as immutable after generation
- Employee earnings records are immutable
- Order summaries cannot be modified

## 🎓 Academic Evaluation Points

1. **Complete Role-Based System**: Three distinct user types with separate dashboards
2. **Real-World Business Logic**: Not a simple CRUD app
3. **CS Concepts**: Properly integrated where they naturally fit
4. **Production-Ready Code**: Proper error handling, validation, security
5. **Modern UI**: Professional admin dashboard design
6. **RESTful API**: Clean, well-structured endpoints
7. **Database Design**: Proper relationships and constraints

## 📄 License

This project is created for academic purposes.

## 👨‍💻 Author

Built as a comprehensive full-stack demonstration project.
