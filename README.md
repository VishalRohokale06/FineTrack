# FinTrack — AI Powered Personal Finance Management App

FinTrack is a full-stack personal finance management application that helps users track expenses, manage budgets, monitor income, and receive AI-powered financial recommendations through intelligent analytics and personalized financial insights.

---

## Features

### Core Finance Features

* Secure JWT Authentication & Authorization
* Expense Tracking & Management
* Income Tracking & Management
* Budget Planning & Monitoring
* Recurring Expense Automation
* Category-Based Expense Analysis
* Financial Analytics Dashboard
* Smart Budget Alerts
* PDF Financial Reports

### AI Features

* AI Personal Finance Advisor
* Spring AI + Ollama (Llama 3) Integration
* Personalized Financial Recommendations
* Context-Aware AI Responses Based on User Data
* Spending Analysis & Savings Suggestions
* Budget-Aware Financial Guidance
* AI Financial Health Insights

### Additional Features

* Responsive Flutter UI
* REST API Integration
* Pull-to-Refresh Dashboard
* Modern Analytics Visualizations
* Cross-Platform Support (Android, Web, Desktop)
* Dockerized Backend Deployment

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
* Spring AI
* Hibernate / JPA
* PostgreSQL

## AI & Machine Learning

* Ollama
* Llama 3
* Spring AI Chat Client
* Personalized Financial Context Engine

## DevOps

* Docker
* Docker Compose
* Git
* GitHub

---

# Project Structure

```text
FinTrack/
│
├── finetrackfrontend/
│   ├── lib/
│   ├── assets/
│   └── pubspec.yaml
│
├── finetrackbackend/
│   ├── src/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── pom.xml
│
└── README.md
```

---

# Screenshots

## Authentication

* Login Screen
* Registration Screen

## Dashboard

* Financial Overview
* Income & Expense Summary
* Spending Analytics
* Budget Tracking

## Expense Management

* Add Expense
* Expense History
* Category Analysis

## AI Financial Advisor

* AI Chat Interface
* Personalized Financial Suggestions
* Budget & Savings Recommendations

---

# Installation & Setup

## Frontend Setup

```bash
cd finetrackfrontend
flutter pub get
flutter run
```

## Backend Setup

```bash
cd finetrackbackend
mvn spring-boot:run
```

---

# Docker Setup

Build and run the backend using Docker:

```bash
docker-compose up --build
```

Run in detached mode:

```bash
docker-compose up -d
```

Stop containers:

```bash
docker-compose down
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

spring.ai.ollama.base-url=http://localhost:11434
spring.ai.ollama.chat.options.model=llama3
```

---

# API Features

* Authentication APIs
* Expense Management APIs
* Income Management APIs
* Budget Management APIs
* Dashboard Analytics APIs
* AI Chatbot APIs
* Financial Insight APIs

---

# AI Personal Finance Advisor

The AI Advisor uses Spring AI and Ollama (Llama 3) to provide personalized financial recommendations.

Examples:

* How can I save more money?
* Where am I overspending?
* Can I afford a ₹15,000 phone this month?
* How much should I save next month?
* Which category is consuming most of my income?

The AI analyzes:

* User Income
* User Expenses
* Savings
* Budget Status
* Spending Categories

to generate context-aware financial guidance.

---

# Future Improvements

* AI Expense Prediction
* Financial Health Score
* AI Monthly Financial Reports
* Investment Suggestions
* Voice-Based Expense Entry
* Cloud Synchronization
* Multi-Device Support

---

# Author

## Vishal Rohokale

* Full Stack Developer
* Flutter Developer
* Java & Spring Boot Developer

GitHub:
https://github.com/VishalRohokale06
