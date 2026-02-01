# 2FA Simple Bypass

## Lab Source
PortSwigger Web Security Academy  
Level: Apprentice  
Category: Authentication

## Overview
This lab shows how weak implementation of two-factor authentication (2FA) can allow attackers to bypass it completely.

## What I Did
- Logged in with valid credentials.
- Analyzed the 2FA verification flow using Burp Suite.
- Identified missing or improperly enforced validation steps.
- Bypassed the 2FA mechanism by manipulating the request flow.

## Result
The application allowed access without proper 2FA verification.

## Impact
- Users are not protected even when 2FA is enabled.
- Attackers can gain unauthorized access after initial login.

## What I Learned
- 2FA must be enforced server-side.
- Authentication flows should not rely on client-side checks.
