# Username Enumeration via Response Timing

## Lab Source
PortSwigger Web Security Academy  
Level: Practitioner  
Category: Authentication

## Overview
This lab demonstrates how attackers can enumerate valid usernames by analyzing subtle differences in server response times during the login process.
Even when error messages are identical, variations in response timing can reveal whether a username exists in the application.

## What I Did
- Intercepted login requests using Burp Suite
- Sent multiple authentication attempts with different usernames
- Measured and compared server response times
- Identified timing delays that indicated valid usernames
- Used the enumerated username for further authentication attacks

## Result
A valid username was successfully identified based solely on response timing differences.

## Impact
-  Usernames can be enumerated without visible error message differences
-  Authentication mechanisms leak sensitive information through timing
-  Enables more effective brute-force and credential-based attacks

## What I Learned
- Identical error messages do not fully prevent information disclosure
- Response timing is a critical side-channel in authentication systems
- Secure authentication requires consistent server-side processing
