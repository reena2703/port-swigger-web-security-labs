# Broken Brute-Force Protection (IP Block)

## Lab Source
PortSwigger Web Security Academy  
Level: Practitioner  
Category: Authentication

## Overview
This lab demonstrates how a flawed brute-force protection mechanism can be bypassed due to poor login attempt tracking and reset logic.
Although the application blocks an IP address after multiple failed login attempts, the protection can be defeated by logging in with a valid account before reaching the block limit.

## What I Did
- Observed IP blocking after multiple failed login attempts
- Identified that logging in with a valid account resets the failed attempt counter
- Used Burp Intruder with a pitchfork attack to alternate valid and victim usernames
- Controlled request order using a single-threaded resource pool
- Brute-forced the victim’s password without triggering a permanent block

## Result
Successfully logged into the victim’s account despite brute-force protection being enabled.

## Impact
- Brute-force protection can be bypassed
- Unauthorized account access is possible
- IP-based defenses alone are insufficient

## Tools Used
- Burp Suite (Proxy)
- Burp Suite Intruder (Pitchfork attack)
- Burp Suite Resource Pool
- Web Browser
  
## What I Learned
- Authentication rate-limiting must be carefully implemented
- Login counters should not reset across different users
- Logical flaws can completely break security controls
