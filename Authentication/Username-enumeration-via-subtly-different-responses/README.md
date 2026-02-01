# Username Enumeration via Subtly Different Responses

## Lab Source
PortSwigger Web Security Academy  
Level: Practitioner  
Category: Authentication

## Overview
This lab focuses on identifying username enumeration vulnerabilities where differences in responses are very subtle and easy to miss.

## What I Did
- Captured login requests using Burp Suite.
- Carefully compared response length, timing, and behavior.
- Identified subtle differences that revealed valid usernames.

## Result
Valid usernames could be identified despite nearly identical error messages.

## Impact
- Enables stealthy user enumeration.
- Makes targeted attacks more effective.

## What I Learned
- Enumeration issues are not always obvious.
- Careful analysis of responses is essential in authentication testing.
