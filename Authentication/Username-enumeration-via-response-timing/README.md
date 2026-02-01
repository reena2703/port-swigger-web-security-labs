# Username Enumeration via Response Timing

This lab demonstrates how small differences in server response time can be used to enumerate valid usernames, even when error messages appear identical.

Although the application attempts to prevent username enumeration by returning the same error message for all login failures, the backend processing time differs depending on whether the username exists. By carefully analyzing these timing differences, it is possible to identify valid usernames and then perform a successful login.

## What I Learned
- Username enumeration does not rely only on error messages
- Response timing can leak sensitive information
- Rate limiting and artificial delays can still be bypassed
- Burp Suite Intruder is useful for detecting subtle timing differences

## Skills Practiced
- Login request analysis
- Response time comparison
- Using Burp Intruder for timing attacks
- Identifying logic flaws in authentication mechanisms

## Tools Used
- Burp Suite
- Burp Intruder

## Lab Status
Solved
