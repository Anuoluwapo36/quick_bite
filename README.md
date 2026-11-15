# Quick Bite

Quick Bite is a food ordering website, built with Java. Customers can sign up, browse a menu, customise the food they want, place an order, and check on it afterwards. An admin dashboard sits on the other side of the same database, letting staff manage the menu, move orders through their stages, and look at how the business is doing.

![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Jakarta Servlet](https://img.shields.io/badge/Jakarta%20Servlet-6.0-007396?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-8-4479A1?style=for-the-badge&logo=mysql)
![JSP](https://img.shields.io/badge/JSP-2.3-D22128?style=for-the-badge)

---

## What It Does

A visitor lands on a marketing page describing the service, then creates an account with an email address and password. From there they can browse every item on the menu, grouped by category — burgers, chicken, pizza, sides, drinks, desserts.

Each product page shows the food, its price, and a set of images. The customer picks a quantity and any extra toppings they want, then continues to checkout.

At checkout they choose between delivery and pickup, and between paying by card or by cash. Card details are checked for a valid format before the order is accepted. The final price is worked out on the server — the base price, the toppings, a delivery fee, and tax — so the number the customer sees always comes from the same place.

Once the order goes through, it lands in the admin dashboard. Staff can see every incoming order, look at the details of any single order, and move it along as it progresses from pending to preparing to delivered. Customers get their own order history page listing everything they have ordered, with its current status and payment details.

---

## Features

**For customers**

- Landing page with service overview
- Sign up, log in, log out, and password reset
- Menu browsing by category
- Product pages with images, description, and price
- Order customisation — quantity plus optional toppings
- Checkout with delivery or pickup and card or cash payment
- Order history with live status and a recent activity feed
- Profile page where name, phone number, and address can be updated
- Settings page for changing the password

**For admins**

- Dashboard showing today's revenue, completed orders, average order value, and a count of orders by status
- Full product management — create, edit, and delete menu items
- Multi-image upload when adding or editing a product, with individual image deletion
- Order management — list every order, open one to see the full detail, and change its status
- Sales reports — total revenue, order totals, new customers, cancellation rate, revenue per day, top-selling products, a weekly sales report, and the busiest ordering hours
- Settings page for company details
- Caching disabled on admin pages so data is always current

**Throughout**

- Password changes and profile edits are recorded in audit tables, so there is a history of what changed
- Deleted accounts are flagged rather than removed, so their order history stays intact
- All database queries use prepared statements, so user input is never pasted into SQL

---

## How It's Built

The backend is written in Java using the Servlet API. Each screen has its own servlet class that reads the request, asks the data layer for what it needs, and forwards the result to a page for rendering.

Pages are written in JSP, which lets Java and HTML live in the same file. Styles are hand-written CSS, and icons come from Font Awesome.

Data is stored in MySQL and accessed directly through JDBC. There is no ORM and no framework — the SQL is written by hand in a dedicated data-access class for each part of the system, which then maps the results into plain Java objects that the pages read from.

The project is laid out in three layers: servlets handle requests, data-access classes handle the database, and model classes carry the data between them.

---

## Tech Stack

| | |
|---|---|
| **Language** | Java 17 |
| **Web framework** | Jakarta Servlet 6.0 |
| **View layer** | JSP with JSTL |
| **Database** | MySQL 8 via plain JDBC |
| **Frontend** | Server-rendered HTML, custom CSS, Font Awesome |
| **Libraries** | MySQL Connector/J, Gson, jBCrypt |

---

## Screens

**Customer pages** — landing page, login, sign up, forgot password, menu, product detail, checkout, order history, profile, and settings.

**Admin pages** — admin login, dashboard, reports, product list, add product, edit product, product images, order list, order details, and settings.

---

## Running the Project

Open the project in IntelliJ IDEA and configure it as a Tomcat web application, with `src/main/webapp` set as the web resource directory. Point the connection details in `DBConnection.java` at your own MySQL instance, create the tables the application expects, and run. The app is then available on the configured Tomcat port.

The project needs **JDK 17 or newer** and **Tomcat 10.1 or newer**, since it is built on the `jakarta.servlet` API.

---

## License

Released under the [MIT License](LICENSE).

---

## Author

Built by **Anuoluwapo Majekobaje Emmanuel** — CS undergraduate at Nanchang University.
