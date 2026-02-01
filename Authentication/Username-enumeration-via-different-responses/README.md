# Username Enumeration via Different Responses

## Lab Source
PortSwigger Web Security Academy  
Level: Apprentice  
Category: Authentication

## Overview
This lab demonstrates how an application can unintentionally leak information during the login process by returning different responses for valid and invalid usernames. This behavior allows attackers to enumerate valid users.

## What I Did
- Intercepted login requests using Burp Suite.
- Tested multiple username and password combinations.
- Observed differences in server responses based on whether the username existed.
- Used these response differences to identify valid usernames.

## Key Observations
- Login error messages were not consistent.
- Response behavior changed depending on username validity.
- Even small differences can reveal sensitive information.

## Result
The application was vulnerable to username enumeration, allowing attackers to identify valid user accounts before attempting password attacks.

## Impact
- Enables targeted brute-force or credential stuffing attacks.
- Increases the risk of account compromise.
- Weakens overall authentication security.

## Tools Used
- Burp Suite
- Web Browser

## What I Learned
- How authentication responses can leak user information.
- Why consistent error handling is critical in login functionality.
- How small logic flaws can have serious security impact.
