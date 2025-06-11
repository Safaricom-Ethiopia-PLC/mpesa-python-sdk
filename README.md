# mpesa-python-sdk - M-Pesa SDK for Python

[![PyPI version](https://img.shields.io/pypi/v/mpesa-python-sdk.svg)](https://pypi.org/project/mpesa-python-sdk) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://mit-license.org/Safaricom-Ethiopia-PLC)

## Overview

The M-Pesa Python SDK simplifies the integration of your Python applications with the M-Pesa API, enabling seamless access to mobile money services such as payments, payouts, and transaction management. This SDK is designed to accelerate your development by providing a robust interface for M-Pesa’s STK Push, C2B, B2C, and authentication APIs.

## Features

- **Authentication**: Retrieve OAuth2 access tokens.
- **STK Push**: Initiate mobile money payments from customers.
- **Customer to Business (C2B)**: Process customer payments with validation and confirmation callbacks.
- **Business to Customer (B2C)**: Payouts for salaries, rewards, or refunds.
- **Error Handling**: Comprehensive exception management.
- **Logging**: Built-in logging for debugging and monitoring.

## Requirements

- Python 3.7 or higher
- An M-Pesa API developer account
- Consumer Key and Consumer Secret from the M-Pesa API portal
- Publicly accessible callback URLs (for C2B and B2C)

## Installation

Install the SDK using pip:

```bash
pip install mpesa-python-sdk
```

## Configuration Guide

### Option 1: Using Environment Variables

This is the recommended approach to keep your credentials and configuration secure and centralized.

1. **Create a `.env` File**

Place a `.env` file in your project root with the following content:

```dotenv
# API Base URL and Endpoints
BASE_URL=https://sandbox.safaricom.et
TOKEN_GENERATE_ENDPOINT=/v1/token/generate
STK_PUSH_ENDPOINT=/mpesa/stkpush/v1/processrequest
C2B_REGISTER_URL_ENDPOINT=/mpesa/c2b/v1/registerurl
C2B_PAYMENTS_ENDPOINT=/mpesa/c2b/v1/simulate
B2C_PAYMENT_REQUEST_ENDPOINT=/mpesa/b2c/v1/paymentrequest

# Authentication
CLIENT_KEY=your_client_key
CLIENT_SECRET=your_client_secret

# Logging and Environment
TIMEOUT=30
MPESA_LOG_DIR=./logs
LOG_LEVEL=DEBUG
ENVIRONMENT=DEV  # Set to TEST to disable console logging
```

2. **Access Configuration in Code**

The SDK automatically loads these variables using the `dotenv` package:

```python
from mpesa import Config

# Access configuration
print("Base URL:", Config.BASE_URL)
print("Client Key:", Config.CLIENT_KEY)
```

### Option 2: Overriding Configuration Directly

If you don’t want to use environment variables or need to change settings dynamically, you can override the configuration directly in your application.

#### Example

```python
# Override configuration
Config.BASE_URL = "https://production.safaricom.et"
Config.CLIENT_KEY = "your_production_client_key"
Config.CLIENT_SECRET = "your_production_client_secret"
Config.ENVIRONMENT = "TEST"  # Disable console logs in production

print("Base URL:", Config.BASE_URL)
```

### Handling Changes in Endpoints

If M-Pesa updates its endpoints or you need to switch between environments (sandbox/production), you can easily update the relevant endpoints:

#### Example

```python
# Set custom endpoint
Config.STK_PUSH_ENDPOINT = "/custom/stkpush/v1/processrequest"
print("Updated STK Push Endpoint:", Config.STK_PUSH_ENDPOINT)
```

## Usage

### Step 1: Authentication

Authenticate with the M-Pesa API to retrieve the access token.

```python
from mpesa import Auth

auth = Auth(
    consumer_key="your_consumer_key",
    consumer_secret="your_consumer_secret",
    base_url="https://sandbox.safaricom.et"
)

response = auth.get_access_token()
print("Access Token:", response.get("access_token"))
```

### Step 2: STK Push Integration

Send an STK Push request to initiate a payment from a customer.

```python
from mpesa import STKPush

stk_push = STKPush(
    base_url="https://sandbox.safaricom.et",
    access_token=access_token
)

payload = stk_push.create_payload(
    short_code="174379",
    pass_key="your_pass_key",
    BusinessShortCode="174379",
    Amount="1000",
    PartyA="254712345678",
    PartyB="174379",
    PhoneNumber="254712345678",
    CallBackURL="https://example.com/callback",
    AccountReference="INV123456",
    TransactionDesc="Payment for Invoice #123456"
)

response = stk_push.send_stk_push(payload)
print("STK Push Response:", response)
```

### Step 3: C2B Payment

Register URLs and process customer payments.

```python
from mpesa import C2B

c2b = C2B(base_url="https://sandbox.safaricom.et", access_token=access_token)

# Register validation and confirmation URLs
registration_response = c2b.register_url(payload={
    "ShortCode": "123456",
    "ResponseType": "Completed",
    "CommandID": "RegisterURL",
    "ConfirmationURL": "https://example.com/confirmation",
    "ValidationURL": "https://example.com/validation"
})

# Process a payment
payment_response = c2b.make_payment(payload={
    "ShortCode": "123456",
    "CommandID": "CustomerPayBillOnline",
    "Amount": "500",
    "Msisdn": "254700000000",
    "BillRefNumber": "INV12345"
})

print("Payment Response:", payment_response)
```

### Step 4: B2C Payout

Send payments to customers.

```python
from mpesa import B2C

b2c = B2C(
    base_url="https://api.safaricom.et",
    access_token=access_token
)

payload = {
    "amount": 5000,
    "partyA": "600000",
    "partyB": "254712345678",
    "remarks": "Loan Disbursement",
    "queueTimeoutURL": "https://yourcallback.url/timeout",
    "resultURL": "https://yourcallback.url/result"
}

response = b2c.make_payment(payload)
print(response)
```

## Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository** on GitHub.
2. **Clone your fork** to your local machine.

   ```bash
   git clone https://github.com/Safaricom-Ethiopia-PLC/mpesa-python-sdk.git
   ```

3. **Create a new feature branch**.

   ```bash
   git checkout -b feature/<your-feature-name>
   ```

4. **Make your changes** and commit them.

   ```bash
   git commit -am "Add new <short feature description>"
   ```

5. **Push your branch** to your fork.

   ```bash
   git push origin feature/<your-feature-name>
   ```

6. **Open a pull request** from your branch to the main repository.

## License

This project is licensed under the [MIT License](https://mit-license.org/Safaricom-Ethiopia-PLC). See the [LICENSE](LICENSE) file for more details.

---

_Happy coding with M-Pesa Python SDK!_
