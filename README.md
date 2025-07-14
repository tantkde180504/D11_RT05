# 🧾 Model Product Ordering System

A full-stack web application that enables users to browse, search, and order collectible model products with role-based access for Customers, Staff, and Admins.

---

## 📌 Project Description

This system is an e-commerce platform built for model product enthusiasts. It provides features like product search, user authentication, cart & order management, product reviews, and backend inventory/reporting tools for staff and admin users.

---

## 🚀 Features

### 👤 **Customer (Guest & Registered Users)**

* Register, login, and manage personal profile
* Browse and search products by category, price, scale, brand
* Add to cart, place order, and choose payment method (VNPay/COD)
* Track order status and view order history
* Submit product reviews and contact store support

### 🛠️ **Staff**

* Confirm/cancel orders
* Print invoices
* Update delivery status and stock levels
* Handle return/exchange requests
* Respond to customer complaints

### 🔧 **Admin**

* Full access to staff permissions
* Manage products, categories, users, and roles
* Assign staff and ban users
* Export reports and view sales statistics

---

## 🛠️ Tech Stack

| Layer          | Technology                                           |
| -------------- | ---------------------------------------------------- |
| **Frontend**   | HTML5, CSS3, JavaScript ES6+, React.js              |
| **Backend**    | Java 11, Spring Boot 3.2.5, Maven, Jakarta EE 10   |
| **Database**   | Azure SQL Server, JPA/Hibernate                     |
| **Cloud**      | Azure (Storage, Key Vault, Identity, App Service)   |
| **Security**   | Spring Security, Google OAuth2, JWT                 |
| **Dev Tools**  | NetBeans, VS Code, Git, Postman, Figma, Maven       |
| **Build/CI**   | Maven, GitHub Actions (planned)                     |

📋 **Xem thêm**: [Chi tiết Quản lý Dự án](PROJECT_MANAGEMENT.md) - Mô hình triển khai, công cụ quản lý và công nghệ

---

## ⚙️ Installation & Run

### Prerequisites
- Java 11 or higher
- Maven 3.6+
- SQL Server or Azure SQL Database
- Node.js 16+ (for React frontend)

### 1. **Clone the repository**

```bash
git clone https://github.com/tantkde180504/D11_RT05.git
cd D11_RT05
```

### 2. **Backend Setup (Spring Boot)**

```bash
# Build the project
mvn clean compile

# Run the application
mvn spring-boot:run
```

The backend will start on `http://localhost:8080`

### 3. **Database Setup**
   * Create Azure SQL Database or local SQL Server instance
   * Update connection settings in `application.properties`
   * Run the provided SQL migration scripts

### 4. **Frontend Setup (React)**

```bash
cd frontend
npm install
npm start
```

The frontend will start on `http://localhost:3000`

### 5. **Configuration**
   * Configure Google OAuth2 credentials (see `GOOGLE_OAUTH_SETUP.md`)
   * Set up Azure services (Storage, Key Vault)
   * Update environment variables for production deployment

---

## 📁 Project Structure

```
D11_RT05/
├── src/main/
│   ├── java/com/mycompany/
│   │   ├── config/              # Spring Security & Web configuration
│   │   ├── controller/          # REST API controllers
│   │   ├── model/               # JPA entities (Product, Review, User)
│   │   ├── repository/          # Data access layer
│   │   ├── service/             # Business logic layer
│   │   └── Application.java     # Spring Boot main class
│   ├── resources/
│   │   ├── application.properties # Configuration
│   │   └── META-INF/persistence.xml
│   └── webapp/                  # JSP views & static files
├── target/                      # Maven build output
├── pom.xml                      # Maven dependencies
├── PROJECT_MANAGEMENT.md        # Detailed project management docs
├── GOOGLE_OAUTH_SETUP.md       # OAuth setup guide
└── README.md                    # This file
```

---

## 🧪 Sample Accounts

| Role     | Username   | Password |
| -------- | ---------- | -------- |
| Customer | customer01 | 123456   |
| Staff    | staff01    | 123456   |
| Admin    | admin01    | 123456   |

---

## 📈 Project Status & Development Model

**Development Model**: Agile/Scrum with iterative development

**Current Progress:**
- ✅ **Iteration 1**: Basic Authentication, Product Browsing, Order Placement
- 🛠️ **Iteration 2** (in-progress): Staff/Inventory Management, Order Tracking  
- 🔜 **Iteration 3**: Advanced Reporting, Production Deployment

**Architecture**: 3-Tier (React Frontend + Spring Boot API + Azure SQL)
**Deployment**: Cloud-Native on Microsoft Azure
**Management Tools**: Git/GitHub, Maven, Spring Boot DevTools

📋 **[Detailed Project Management Documentation](PROJECT_MANAGEMENT.md)** - Comprehensive guide covering deployment models, management tools, and complete technology stack.

---

## 🧠 Known Issues / To Be Clarified

* Whether guests can place items in cart before registration
* Final design for delivery staff & delivery API
* Admin vs. Staff permission overlaps on order data

---

## 📧 Contact

For feedback or questions, contact:
📮 `tantkde180504@fpt.edu.vn`
📚 Supervised by: \[Lecturer's Name]


