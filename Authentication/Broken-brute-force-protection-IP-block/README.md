# Broken Brute-Force Protection (IP Block)

This lab demonstrates how poorly implemented brute-force protection can be bypassed due to a logic flaw in the authentication flow.

Although the application blocks an IP address after multiple failed login attempts, the counter for failed attempts can be reset by successfully logging in with a valid account. This allows an attacker to continue brute-forcing another user’s password without being permanently blocked.

## What I Learned
- IP-based brute-force protection can be ineffective if logic flaws exist
- Login attempt counters can sometimes be reset unintentionally
- Authentication protections must be tested from an attacker’s perspective
- Sequential request handling is important for exploiting logic flaws

## Skills Practiced
- Brute-force attack analysis
- Authentication logic testing
- Burp Suite Intruder (sniper attack)
- Resource pool configuration for ordered requests

## Tools Used
- Burp Suite
- Burp Intruder

## Lab Status
Solved
