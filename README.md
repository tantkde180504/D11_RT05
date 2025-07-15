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
* Add to cart, place order, and choose payment method (PayOS/COD)
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

| Layer     | Technology                              |
| --------- | --------------------------------------- |
| Frontend  | HTML, CSS, JavaScript, React.js         |
| Backend   | Java Web (Maven, Spring MVC structure)  |
| Database  | SQL Server                              |
| Dev Tools | VS Code / NetBeans, Postman, Figma, Git |

---

## ⚙️ Installation & Run

1. **Clone the repo**

```bash
git clone https://github.com/tantkde180504/D11_RT05.git
cd model-ordering-system
```

2. **Set up Database**

   * Create a new SQL Server database
   * Run the provided SQL script to initialize schema and seed data

3. **Backend Setup (NetBeans)**

   * Open project in NetBeans (as Maven project)
   * Configure DB connection in `dbconfig.properties`
   * Deploy to Tomcat or local servlet container

4. **Frontend Setup (React)**

```bash
cd frontend
npm install
npm start
```

---

## 📁 Folder Structure (Simplified)

```

```

---

## 🧪 Sample Accounts

| Role     | Username   | Password |
| -------- | ---------- | -------- |
| Customer | customer@gundam.com | customer123   |
| Staff    | staff@gundam.com    | staff123   |
| Admin    | admin@gundam.com    | admin123   |

---

## 📈 Project Status

✅ Iteration 1: Basic Authentication, Product Browsing, Order Placement
🛠️ Iteration 2 (in-progress): Staff/Inventory Management, Order Tracking
🔜 Iteration 3: Advanced Reporting, Deployment

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


