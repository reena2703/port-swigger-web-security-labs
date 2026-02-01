# Password Reset Broken Logic

## Lab Source
PortSwigger Web Security Academy  
Level: Practitioner  
Category: Authentication

## Overview
This lab demonstrates how flaws in password reset logic can allow attackers to reset passwords without proper verification.

## What I Did
- Intercepted password reset requests.
- Analyzed how reset tokens and parameters were handled.
- Manipulated request logic to bypass intended security checks.

## Result
The password reset functionality could be abused due to broken logic.

## Impact
- Full account takeover is possible.
- Sensitive user accounts can be compromised.

## What I Learned
- Password reset functionality is a critical attack surface.
- All reset steps must be securely validated on the server.
