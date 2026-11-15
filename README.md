# Quick Bite

A full-stack food ordering web application built with **Java Servlets, JSP, and MySQL**. Customers browse a menu, customise an order, check out, and track their order history. An admin dashboard handles the menu, order pipeline, analytics, and site settings.

![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Jakarta Servlet](https://img.shields.io/badge/Jakarta%20Servlet-6.0-007396?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-8-4479A1?style=for-the-badge&logo=mysql)
![JSP](https://img.shields.io/badge/JSP-2.3-D22128?style=for-the-badge)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [Configuration](#configuration)
- [Database Schema](#database-schema)
- [URL Reference](#url-reference)
- [Roadmap](#roadmap)
- [Known Issues](#known-issues)
- [License](#license)

---

## Overview

**Quick Bite** is a fast food delivery platform built as a Java web application. It splits cleanly into two applications sharing one database:

**Customer side** — a marketing landing page, email/password signup and login, a browsable menu, product detail pages with topping customisation, a checkout flow with card or cash payment, order history, and a profile with editable contact details.

**Admin side** — a dashboard with revenue and order metrics, full product CRUD with multi-image upload, an order management pipeline with status transitions, sales reports, and site settings.

The project is built on plain JDBC with `PreparedStatement` throughout, Jakarta Servlets for request routing, and JSP for rendering. There is no ORM and no framework — the data layer is hand-written SQL.

---

## Features

### Customer
- **Landing page** — hero section, feature grid, app download section, footer
- **Account management** — signup, login, logout, password reset, profile editing
- **Menu browsing** — all products, filtered by category
- **Product detail** — image gallery, description, price
- **Order customisation** — toppings at $0.50 each, quantity selection
- **Checkout** — delivery or pickup, card or cash payment, live price calculation
- **Order history** — past orders with status, payment details, and a recent-activity feed
- **Session management** — login state persisted in `HttpSession`

### Admin
- **Dashboard** — today's revenue, completed orders, average order value, order counts by status
- **Product management** — create, edit, and delete products, including multi-image upload and per-image deletion
- **Order management** — list all orders, view details, advance order status
- **Reports** — total revenue, order totals, new customer count, cancellation rate, revenue per day, top-selling products, weekly sales report, and peak ordering hours
- **Settings** — company details and site configuration
- **Cache control** — `NoCacheFilter` applied to all `/admin/*` routes so admin pages never serve stale content

### Cross-cutting
- **Audit trails** — profile edits recorded in `customer_audit`, password changes in `password_audit`
- **Soft deletes** — customers are flagged with `is_deleted` rather than removed, so history survives
- **Order price calculation** — base price + toppings + delivery fee + tax, computed server-side
- **Prepared statements everywhere** — all SQL goes through `PreparedStatement`, no string concatenation of user input

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Language** | Java 17 |
| **Web framework** | Jakarta Servlet 6.0 (annotation-based, no `web.xml` mappings) |
| **View layer** | JSP with JSTL and EL |
| **Database** | MySQL 8, accessed through plain JDBC |
| **Build** | Maven-style `src/main/java` + `src/main/webapp` layout, deployed to Tomcat |
| **Frontend** | Server-rendered HTML, hand-written CSS, Font Awesome icons via CDN |
| **Libraries** | `mysql-connector-j-9.4.0`, `gson-2.10.1`, `jbcrypt-0.4` |

---

## Project Structure

```text
quick_bite-main/
├── .gitignore
├── README.md
├── build/                              # compiled classes (should not be committed)
└── src/main/
    ├── java/com/quick_bite/
    │   ├── controller/                 # customer-facing servlets
    │   │   ├── LandingServlet.java
    │   │   ├── LoginServlet.java
    │   │   ├── LogoutServlet.java
    │   │   ├── SignupServlet.java
    │   │   ├── HomeServlet.java
    │   │   ├── ProductDetailServlet.java
    │   │   ├── PlaceOrderServlet.java
    │   │   ├── OrderHistoryServlet.java
    │   │   ├── ProfileServlet.java
    │   │   └── SettingsServlet.java
    │   ├── servlet/                    # admin-facing servlets
    │   │   ├── AdminLoginServlet.java
    │   │   ├── DashboardServlet.java
    │   │   ├── ReportServlet.java
    │   │   ├── ProductsServlet.java
    │   │   ├── AddProductServlet.java
    │   │   ├── EditProductServlet.java
    │   │   ├── UpdateProductServlet.java
    │   │   ├── DeleteProductServlet.java
    │   │   ├── DeleteProductImageServlet.java
    │   │   ├── OrderServlet.java
    │   │   ├── OrderDetailsServlet.java
    │   │   ├── OrderViewServlet.java
    │   │   ├── OrderActionServlet.java
    │   │   ├── SettingsServlet.java
    │   │   ├── LogoutServlet.java
    │   │   ├── ForgotPasswordServlet.java
    │   │   └── NoCacheFilter.java
    │   ├── dao/                       # data access layer (plain JDBC)
    │   │   ├── CustomerDAO.java
    │   │   ├── AdminDAO.java
    │   │   ├── ProductDAO.java
    │   │   ├── OrderDAO.java
    │   │   ├── PaymentDAO.java
    │   │   ├── ReportDAO.java
    │   │   └── ActivityDAO.java
    │   ├── model/                     # POJOs
    │   │   ├── Customer.java
    │   │   ├── Admin.java
    │   │   ├── Product.java
    │   │   ├── ProductImage.java
    │   │   ├── Order.java
    │   │   ├── OrderItem.java
    │   │   ├── Payment.java
    │   │   ├── Activity.java
    │   │   ├── TopProduct.java
    │   │   └── WeeklySalesReport.java
    │   └── sqlconnection/
    │       └── DBConnection.java      # JDBC connection factory
    └── webapp/
        ├── index.jsp                  # landing page
        ├── forgotpassword.jsp
        ├── META-INF/MANIFEST.MF
        ├── admin/
        │   ├── index.jsp
        │   ├── css/                   # 12 stylesheets
        │   └── dashboard/              # 10 admin JSPs
        └── WEB-INF/
            ├── web.xml
            ├── lib/                    # 3 bundled JARs
            └── view/customer/          # 7 customer JSPs
```

**Layers:** `Servlet → DAO → DBConnection → MySQL`, with `model` classes carrying data between them and `view/customer` + `admin/dashboard` JSPs rendering it.

---

## Architecture

The app follows a classic **Servlet → DAO → Model** three-layer pattern.

- **Servlet layer** — each servlet owns one route. It reads parameters, calls the appropriate DAO, sets request attributes, and forwards to a JSP. Business rules that are specific to one action (like checkout validation) live here.
- **DAO layer** — static methods, one class per aggregate. Each opens a connection, runs a `PreparedStatement`, and maps the `ResultSet` into model objects. Errors are caught, printed to the stack trace, and swallowed.
- **Model layer** — plain POJOs with getters and setters, plus nested `List<ProductImage>`, `List<OrderItem>`, and `Payment` references assembled by the DAOs.

**Views** live under `WEB-INF/view/customer/` and `admin/dashboard/` so they cannot be requested directly — only reached through a servlet forward. The landing page at `webapp/index.jsp` is the exception, since it is a public entry point.

**Request routing** is annotation-based. Every servlet is mapped with `@WebServlet("/path")`, so `web.xml` contains only the welcome-file list and no servlet mappings.

---

## Getting Started

### Prerequisites

| Requirement | Version |
|---|---|
| **JDK** | 17 or newer |
| **Apache Tomcat** | 10.1+ (Jakarta EE 10 — Tomcat 9 will not work) |
| **MySQL** | 8.0+ |
| **IDE** | IntelliJ IDEA (Ultimate) or Eclipse with Jakarta EE support |

> Tomcat 10 is required because the code uses the `jakarta.servlet` namespace. Tomcat 9 ships `javax.servlet` and the app will not deploy on it.

---

## Database Setup

### 1. Create the database

```sql
CREATE DATABASE quick_bite
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

### 2. Create the tables

The project does not ship a schema file. Create the following tables based on the columns used throughout the DAO layer:

**`customer`**

| Column | Type | Notes |
|---|---|---|
| `customer_id` | INT | Primary key, auto increment |
| `full_name` | VARCHAR(255) | |
| `email` | VARCHAR(255) | Unique |
| `password` | VARCHAR(255) | |
| `phone` | VARCHAR(50) | |
| `address` | TEXT | |
| `created_at` | TIMESTAMP | |
| `is_deleted` | TINYINT | Soft-delete flag, default 0 |

**`admin`**

| Column | Type | Notes |
|---|---|---|
| `admin_id` | INT | Primary key, auto increment |
| `admin_username` | VARCHAR(255) | Unique |
| `admin_password` | VARCHAR(255) | |
| `admin_name` | VARCHAR(255) | |
| `admin_email` | VARCHAR(255) | |
| `company_name` | VARCHAR(255) | |
| `company_email` | VARCHAR(255) | |
| `company_phone` | VARCHAR(50) | |
| `company_address` | TEXT | |
| `status` | VARCHAR(20) | Must be `ACTIVE` to log in |

**`categories`**

| Column | Type | Notes |
|---|---|---|
| `category_id` | INT | Primary key, auto increment |
| `category_name` | VARCHAR(255) | Unique |

**`products`**

| Column | Type | Notes |
|---|---|---|
| `product_id` | INT | Primary key, auto increment |
| `product_name` | VARCHAR(255) | |
| `product_desc` | TEXT | |
| `product_price` | DECIMAL(10,2) | |
| `category_id` | INT | Foreign key to `categories` |
| `created_at` | TIMESTAMP | |

**`product_images`**

| Column | Type | Notes |
|---|---|---|
| `image_id` | INT | Primary key, auto increment |
| `product_id` | INT | Foreign key to `products` |
| `image_name` | VARCHAR(255) | Filename stored relative to the upload directory |

**`orders`**

| Column | Type | Notes |
|---|---|---|
| `order_id` | INT | Primary key, auto increment |
| `customer_id` | INT | |
| `customer_name` | VARCHAR(255) | |
| `customer_phone` | VARCHAR(50) | |
| `customer_email` | VARCHAR(255) | |
| `customer_address` | TEXT | |
| `total_amount` | DECIMAL(10,2) | |
| `status` | VARCHAR(50) | `Pending`, `Preparing`, `Delivered`, `Cancelled`, etc. |
| `created_at` | TIMESTAMP | |

**`order_items`**

| Column | Type | Notes |
|---|---|---|
| `item_id` | INT | Primary key, auto increment |
| `order_id` | INT | Foreign key to `orders` |
| `product_id` | INT | Foreign key to `products` |
| `quantity` | INT | |
| `price` | DECIMAL(10,2) | Unit price including toppings |

**`payments`**

| Column | Type | Notes |
|---|---|---|
| `payment_id` | INT | Primary key, auto increment |
| `order_id` | INT | Foreign key to `orders` |
| `customer_id` | INT | |
| `amount` | DECIMAL(10,2) | |
| `payment_method` | VARCHAR(50) | `card` or `cash` |
| `payment_status` | VARCHAR(50) | `PAID` or `PENDING` |
| `transaction_id` | VARCHAR(255) | UUID generated at checkout |
| `payment_date` | TIMESTAMP | |

**`customer_audit`** — `audit_id` INT PK, `customer_id` INT, `field_changed` VARCHAR(255), `old_value` TEXT, `new_value` TEXT, `changed_at` TIMESTAMP

**`password_audit`** — `audit_id` INT PK, `customer_id` INT, `changed_at` TIMESTAMP

### 3. Seed an admin account

The admin login checks `status = 'ACTIVE'`, so the row must be inserted with that value:

```sql
INSERT INTO admin (admin_username, admin_password, admin_name, admin_email, status)
VALUES ('admin', 'admin123', 'Administrator', 'admin@quickbite.com', 'ACTIVE');
```

### 4. Seed categories

```sql
INSERT INTO categories (category_name) VALUES
  ('Burgers'), ('Chicken'), ('Pizza'), ('Sides'), ('Drinks'), ('Desserts');
```

---

## Running the Application

### Option 1 — IntelliJ IDEA

1. Open the project folder.
2. Configure the project as a **Tomcat: Quick Bite** web application.
3. Add the MySQL connector JAR to the deployment if it is not picked up automatically.
4. Make sure `src/main/webapp` is marked as the web resource directory.
5. Set the database credentials in `DBConnection.java`.
6. Run the Tomcat configuration and open `http://localhost:8080/quick_bite/`.

### Option 2 — Manual Tomcat deployment

```bash
# Compile the sources
javac -cp "src/main/webapp/WEB-INF/lib/*" -d build/classes $(find src/main/java -name "*.java")

# Copy the web resources
cp -r src/main/webapp/* $CATALINA_HOME/webapps/quick_bite/

# Start Tomcat
$CATALINA_HOME/bin/startup.sh    # startup.bat on Windows
```

Then open `http://localhost:8080/quick_bite/`.

### Option 3 — Docker

No Dockerfile is included. If you want one, a minimal setup needs Tomcat 10.1 with the MySQL driver and the compiled WAR.

---

## Configuration

### Database credentials

`src/main/java/com/quick_bite/sqlconnection/DBConnection.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/quick_bite?serverTimezone=UTC";
private static final String USER = "root";
private static final String PASSWORD = "your_password_here";
```

### Image uploads

`AddProductServlet` and `UpdateProductServlet` write uploaded files to a directory resolved at runtime:

```java
String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
```

The `UPLOAD_DIR` constant lives in each servlet. Images are stored under the deployed web application directory, and the filename is stored in `product_images.image_name`.

Upload limits are set per servlet with `@MultipartConfig`:

| Servlet | Threshold | Max file size | Max request size |
|---|---|---|---|
| `AddProductServlet` | 1 MB | 10 MB | 50 MB |
| `UpdateProductServlet` | 2 MB | 10 MB | 50 MB |

### Pricing rules

`PlaceOrderServlet` computes the final total server-side:

| Component | Value |
|---|---|
| Topping surcharge | $0.50 each |
| Delivery fee | $2.50 |
| Tax | 8% of the item subtotal |

```java
double extrasPrice = extrasCount * 0.50;
double itemTotal = (basePrice + extrasPrice) * quantity;
double deliveryFee = 2.50;
double tax = itemTotal * 0.08;
double totalAmount = itemTotal + deliveryFee + tax;
```

---

## Database Schema

| Table | Purpose |
|---|---|
| `customer` | Customer accounts, soft-deleted via `is_deleted` |
| `admin` | Admin accounts and company profile |
| `categories` | Product categories |
| `products` | Menu items |
| `product_images` | Images attached to products |
| `orders` | Order header with customer snapshot and total |
| `order_items` | Line items per order |
| `payments` | Payment records with transaction ID |
| `customer_audit` | History of profile field changes |
| `password_audit` | History of password changes |

---

## URL Reference

### Customer

| Method | Path | Servlet | Description |
|---|---|---|---|
| GET | `/` | `index.jsp` | Landing page |
| GET/POST | `/login` | `LoginServlet` | Login form and submission |
| GET/POST | `/signup` | `SignupServlet` | Registration |
| GET/POST | `/logout` | `LogoutServlet` | Sign out |
| GET | `/home` | `HomeServlet` | Menu listing |
| GET | `/quick_bite/food/view` | `ProductDetailServlet` | Product detail |
| POST | `/order/payment` | `PlaceOrderServlet` | Checkout |
| GET | `/orders` | `OrderHistoryServlet` | Order history |
| GET/POST | `/profile` | `ProfileServlet` | Profile view and update |
| GET/POST | `/settings` | `SettingsServlet` | Profile settings, password change |
| GET/POST | `/forgot-password` | `ForgotPasswordServlet` | Password reset |

### Admin

| Method | Path | Servlet | Description |
|---|---|---|---|
| GET/POST | `/adminLogin` | `AdminLoginServlet` | Admin sign-in |
| GET | `/admin/dashboard` | `DashboardServlet` | Metrics overview |
| GET | `/admin/dashboard/report` | `ReportServlet` | Sales reports |
| GET | `/admin/products` | `ProductsServlet` | Product list |
| GET/POST | `/admin/addProduct` | `AddProductServlet` | Create product with images |
| GET/POST | `/admin/edit-product` | `EditProductServlet` | Edit form |
| GET/POST | `/admin/update-product` | `UpdateProductServlet` | Save product changes |
| GET | `/admin/deleteProduct` | `DeleteProductServlet` | Delete a product |
| GET | `/admin/delete-product-image` | `DeleteProductImageServlet` | Delete one image |
| GET | `/admin/orders` | `OrderServlet` | Order list |
| GET | `/admin/orders/view` | `OrderViewServlet` | Order detail |
| GET | `/admin/orderDetails` | `OrderDetailsServlet` | Order details |
| GET/POST | `/admin/orderAction` | `OrderActionServlet` | Change order status |
| GET/POST | `/admin/settings` | `SettingsServlet` | Company settings |
| GET | `/admin/logout` | `LogoutServlet` | Admin sign-out |

---

## Roadmap

- [ ] Add `BCrypt` hashing for customer and admin passwords — the library is already bundled but unused
- [ ] Move credentials out of `DBConnection` into environment variables
- [ ] Add a `pom.xml` so the project builds with Maven instead of an IDE
- [ ] Add a database schema file (`schema.sql`) and a seed script
- [ ] Add proper session validation — admin routes currently rely on the filter for caching only, not for access control
- [ ] Add input validation on the admin side
- [ ] Introduce a service layer between servlets and DAOs
- [ ] Replace `notifyDataSetChanged()` with `DiffUtil` in the admin order list
- [ ] Add JUnit tests for the pricing calculation and the DAO layer
- [ ] Add pagination to the admin order and product lists
- [ ] Add a `LICENSE` file

---

## Known Issues

Issues worth addressing, in rough priority order.

### 1. Passwords are stored and compared in plain text

`jbcrypt-0.4.jar` is bundled in `WEB-INF/lib`, but `BCrypt` is **never imported or called anywhere** in the codebase. Passwords are written to the database and compared as raw strings:

```java
// LoginServlet.java:54
if (!customer.getPassword().equals(password)) {
```

```java
// CustomerDAO.checkPassword
return storedPassword.equals(inputPassword);
```

The same applies to admin login, which compares `admin_password` directly in the SQL query. Anyone with database read access gets every plaintext password. **Hashing with the already-bundled BCrypt is the single highest-value fix in this project.**

### 2. Database credentials are hardcoded

```java
private static final String PASSWORD = "Majekobaje3666@";
```

The real password is committed in `DBConnection.java`. The `.gitignore` excludes a `.env` file, which suggests the intent was to use environment variables — but no code reads them. Move `URL`, `USER`, and `PASSWORD` to `System.getenv()` with sensible fallbacks.

### 3. Admin routes have no access control

`NoCacheFilter` is mapped to `/admin/*`, but it only sets no-cache headers — it does **not** check whether an admin is logged in. Any admin page can be reached without authentication by typing the URL directly. The filter's `doFilter` needs an admin session check with a redirect to `/adminLogin`.

### 4. `build/` is not gitignored

The project contains 45 compiled `.class` files under `build/classes/`, and `.gitignore` does not list `build/`. Those binaries would be committed. Add `build/` and `out/` to `.gitignore` and delete the directory.

### 5. `LandingServlet` is dead code and points at a missing file

`LandingServlet` has no `@WebServlet` annotation, so it is never mapped and can never run. It also forwards to `/WEB-INF/view/customer/index.jsp`, which does not exist — the landing page is at `src/main/webapp/index.jsp` and is served directly as the welcome file. Either delete the servlet or map it and fix the path.

### 6. Card details are accepted but never processed

`PlaceOrderServlet` reads `cardnumber`, `exp`, `cvv`, and `cardHolder` from the form, validates their format, and then **discards them**. The order is marked `PAID` and a random UUID is generated as the transaction ID. No payment gateway is involved. This is fine for a simulation, but the code reads as though a real card is being charged. Either rename it clearly to a mock, or integrate a real gateway.

### 7. `gson-2.10.1.jar` is bundled but never used

No Java file imports `Gson`. It appears to be a leftover. Remove it, or use it — it would suit the report endpoints that currently return raw `Map<String, Double>`.

### 8. `web.xml` uses the outdated Servlet 2.4 schema

```xml
<web-app id="WebApp_ID" version="2.4"
         xmlns="http://java.sun.com/xml/ns/j2ee" ...>
```

The `jakarta` namespace arrived with Servlet 3.0. The descriptor works because all routing is annotation-based, but the old namespace is misleading. Update it to the Servlet 6.0 schema.

### 9. Errors are swallowed

Every DAO method catches `Exception`, calls `printStackTrace()`, and returns an empty list or `false`. A database outage is indistinguishable from "no results" at the call site, and users see a generic failure message. Log through a proper logger and surface real errors.

### 10. Resource handling is inconsistent

Some DAOs use try-with-resources correctly. `AdminDAO.login` does not — it calls `con.close()` manually at the end, which leaks the connection if the query throws. `ProductDAO.getProductById` and several others follow the same pattern.

### 11. `POST` handling on `GET`-only pages

`LoginServlet` overrides both `doGet` and `doPost`, but `ProfileServlet`, `SettingsServlet`, and several admin servlets only implement `doPost`. A `GET` request to those URLs returns `405 Method Not Allowed`.

### 12. Missing project infrastructure

- No `pom.xml` — the project only builds inside an IDE
- No `schema.sql` — the schema must be created by hand
- No `LICENSE` file, though this README references one
- `README` at the project root is a 1-byte empty file (this README replaces it)
- `quick_bite/README.md` is an older duplicate of the documentation

---

## License

Released under the [MIT License](LICENSE).

---

## Author

Built by **Anuoluwapo Majekobaje Emmanuel** — CS undergraduate at Nanchang University.
