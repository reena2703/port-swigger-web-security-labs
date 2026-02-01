# Scanning Non-Standard Data Structures

## Lab Source
PortSwigger Web Security Academy  
Level: Practitioner  
Category: Essential Skills

## Overview
This lab demonstrates how vulnerabilities can exist inside **non-standard data structures**, such as cookies or structured values, which are difficult to identify through manual testing alone. It highlights the importance of using targeted scanning techniques to uncover hidden issues.

## What I Did
- Logged into the application using the provided user credentials.
- Intercepted authenticated requests using Burp Suite.
- Analyzed the session cookie and noticed it contained multiple data elements rather than a single value.
- Selected a specific part of the cookie as an insertion point.
- Used **Burp Scanner’s “Scan selected insertion point”** feature to test this non-standard input.
- Reviewed the scanner findings and manually verified the reported issue.

## Key Observations
- Not all user input appears in URL parameters or form fields.
- Cookies and structured data can contain user-controlled input.
- Manual testing alone would likely miss this vulnerability.
- Targeted scanning helped identify a stored XSS issue efficiently.

## Result
A stored Cross-Site Scripting (XSS) vulnerability was identified within a non-standard data structure. The issue could be manually exploited after being detected by the scanner, confirming the risk.

## Impact
- An attacker could execute malicious JavaScript in another user’s browser.
- This could lead to session hijacking or privilege escalation.
- Demonstrates real-world risk when input inside structured data is not properly handled.

## Tools Used
- Burp Suite (Scanner, Proxy, Repeater, Collaborator)
- Browser Developer Tools

## What I Learned
- How vulnerabilities can hide inside non-traditional input locations.
- The value of scanning specific insertion points instead of entire requests.
- How automated scanning and manual testing work together in real assessments.
