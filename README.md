# FinTrack — AI Powered Personal Finance Management App

FinTrack is a full-stack personal finance management application that helps users track expenses, manage budgets, monitor income, and gain AI-powered financial insights through analytics and smart reporting.

---

## Features

* Secure JWT Authentication & Authorization
* Expense & Income Tracking
* Budget Management
* AI-Based Spending Insights
* Financial Analytics Dashboard
* Recurring Expense Automation
* Push Notifications
* PDF Financial Reports
* Responsive Flutter UI
* REST API Integration
* Dark Mode Support

---

# Tech Stack

## Frontend

* Flutter
* Dart
* Provider
* Dio
* SharedPreferences
* FL Chart

## Backend

* Spring Boot
* Spring Security
* JWT Authentication
* Hibernate / JPA
* PostgreSQL

---

# Project Structure

```text
FinTrack/
│
├── finetrack_frontend/
│   ├── lib/
│   ├── assets/
│   ├── pubspec.yaml
│
├── finetrack_backend/
│   ├── src/
│   ├── pom.xml
│
└── README.md
```

---

# Screenshots -> assets/screenshots

## Authentication Screens

* Login Screen
* Register Screen

## Dashboard

* Analytics Dashboard
* Expense Overview
* Budget Tracking

## Expense Management

* Add Expense
* Expense History
* Category Insights

---

# Installation & Setup

## Frontend Setup

```bash
cd finetrack_frontend
flutter pub get
flutter run
```

## Backend Setup

```bash
cd finetrack_backend
mvn spring-boot:run
```

---

# Backend Configuration

Update `application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/finetrack
spring.datasource.username=your_username
spring.datasource.password=your_password

jwt.secret=your_secret_key
jwt.expiration=86400000
```

---

# API Features

* User Authentication APIs
* Expense Management APIs
* Budget APIs
* Dashboard Analytics APIs
* AI Insights APIs

---

# Future Improvements

* AI Expense Prediction
* Multi-Device Synchronization
* Cloud Backup
* Voice Expense Entry
* Advanced Financial Reports

---

# Author

## Vishal Rohokale

* Java & Spring Boot Developer
* Flutter Developer
* Full Stack Developer

GitHub: https://github.com/VishalRohokale06
