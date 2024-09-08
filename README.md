# Price Alert Application

## Overview
- This application allows users to create alerts for Bitcoin price changes. When the price of Bitcoin hits a user-specified target, an email notification is sent in real time. The system is built using Ruby on Rails and integrates various components for scalability, real-time updates, and asynchronous processing.

## Table of Contents

- [Features](#features)
- [Setup](#setup)
- [API Endpoints](#api-endpoints)
  - [User API](#user-api)
  - [Alerts API](#alerts-api)
- [Background Processing](#background-processing)
- [Email Notifications](#email-notifications)

## Features

- **User Authentication**: Users can create an account and log in.
- **Alert Management**: Users can create, view, and delete price alerts.
- **Real-Time Price Updates**: Uses Binance WebSocket to get real-time Bitcoin prices.
- **Pub/Sub System**: Utilizes Redis Pub/Sub to manage real-time price updates.
- **Email Notifications**: Sends email alerts using Gmail SMTP when the target price is reached.

## Setup

### Prerequisites

Ensure you have Docker and Docker Compose installed on your system.

## Running the Project

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd price_alert_app
   ```
2. Build and run the project:
   ```bash
   docker-compose up --build
    ```
3. Run database migrations:
   ```bash
   docker-compose exec web rails db:create db:migrate
    ```

## Architecture and Design

### Real-Time Price Updates Using WebSockets

We have integrated the `binance-ruby` gem to open a WebSocket connection with Binance and fetch real-time price data for Bitcoin. This continuous stream of price data ensures that the system is always up-to-date, allowing for prompt alert triggers when a user-specified threshold is met.

## API Endpoints
### User API
### Register User
- **Endpoint**: **POST /api/users**
- **Description**: **Registers a new user**
- **Request Body**:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

- **Response**:
```json
{
  "success": true,
  "token": "your_jwt_token"
}
```
### Login User
- **Endpoint**: **POST /api/users/login**
- **Description**: **Authenticates a user and returns a JWT token**.
- **Request Body**:

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
-**Response**:

```json
{
  "success": true,
  "token": "your_jwt_token"
}
```

## Alerts API

The Alerts API allows users to create, view, and delete price alerts for Bitcoin. Alerts are triggered when the Bitcoin price crosses a specified threshold, and an email notification is sent to the user.

### Authentication

Each API request must include the `authentication_token` as part of the headers to authenticate the user.
```bash
Authorization: Token token=<authentication_token>
```

- **Endpoints**
1. **Create an Alert**
**Endpoint**: **POST /api/alerts/create**

**Description**: **Creates a new alert for the authenticated user**.

**Request**:
```bash
POST /api/alerts/create
```
**Request Body**:
```json
{
  "target_price": 50000
}
```
**Response**:
```json
{
    "status": "Alert created",
    "alert": {
        "id": 8,
        "user_id": 3,
        "status": "created",
        "coin": "btc",
        "target_price": 57050.0,
        "created_at": "2024-09-05T14:19:57.457Z",
        "updated_at": "2024-09-05T14:19:57.457Z",
        "alert_type": "above"
    }
}
```
2. **View All Alerts**
**Endpoint: GET /api/alerts**

**Description**: Retrieves all alerts created by the authenticated user.

**Request**:

```bash
GET /api/alerts
```
**Response**:

```json
{
    "alerts": [
        {
            "id": 1,
            "user_id": 3,
            "status": "created",
            "coin": "btc",
            "target_price": 33000.0,
            "created_at": "2024-09-04T23:46:06.255Z",
            "updated_at": "2024-09-04T23:46:06.255Z"
        },
        {
            "id": 2,
            "user_id": 3,
            "status": "created",
            "coin": "btc",
            "target_price": 32000.0,
            "created_at": "2024-09-05T01:23:10.557Z",
            "updated_at": "2024-09-05T01:23:10.557Z"
        },
        {
            "id": 3,
            "user_id": 3,
            "status": "created",
            "coin": "btc",
            "target_price": 32001.0,
            "created_at": "2024-09-05T01:23:20.655Z",
            "updated_at": "2024-09-05T01:23:20.655Z"
        }
    ],
    "status": "Success"
}
```

3 **Delete an Alert**
**Endpoint**: **DELETE /api/alerts/:id**

**Description**: Deletes a specific alert by ID.

**Request**:

```bash
DELETE /api/alerts/1
```
**Response**:

```json
{
  "status": "Alert deleted",
}
```

### Price Updates
The application connects to Binance WebSockets to get live Bitcoin price updates. Once a price update is received, it is published to Redis via Pub/Sub. This triggers background processing to check for any alerts that need to be sent to users.

## Email Notifications
Email notifications are triggered when a price alert condition is met. Sidekiq is used to handle the background job for sending emails. Notifications can be sent through Gmail SMTP.

## Background Processing
### Sidekiq
Sidekiq is used to process email notification jobs asynchronously.

### Redis Pub/Sub
Redis Pub/Sub is used to handle real-time notifications for the price updates. The price data received from Binance is published to Redis, which in turn triggers workers that handle the alert processing.


  
