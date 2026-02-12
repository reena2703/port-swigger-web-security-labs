# PortSwigger Lab – Broken Brute-Force Protection (IP Block)

## Lab Details
Category: Server-Side Authentication (Password-Based)  
Level: Practitioner  
Status: Solved 

---

## What This Lab Is About
This lab demonstrates a **server-side logic flaw in password brute-force protection**.

Although the application blocks an IP address after multiple failed login attempts, the backend **resets the failed-attempt counter when a successful login occurs**. This logic flaw allows an attacker to continuously brute-force a victim’s password without triggering the IP block.

---

## Goal of the Lab
- Bypass the IP-based brute-force protection
- Brute-force Carlos’s password
- Log in and access the victim’s account page

---

## Given Credentials
- My account: `wiener : peter`
- Victim username: `carlos`

---

## Tools Used
- Burp Suite
  - Proxy
  - Intruder (Pitchfork attack)
  - Resource Pool
- Candidate password wordlist

---

## How I Solved It

### 1. Understanding the Brute-Force Protection
With Burp running, I tested the login page and observed that:
- The application blocks my IP after **three consecutive failed login attempts**
- Logging in successfully **resets the failed attempt counter**

This behavior creates a logic flaw that can be exploited.

---

### 2. Preparing the Intruder Attack
I sent the `POST /login` request to **Burp Intruder** and configured a **Pitchfork attack** with payload positions on:
- `username`
- `password`

To preserve request order, I added the attack to a **Resource Pool** with:
```

Maximum concurrent requests = 1

```

---

### 3. Bypassing the IP Block
For the username payload:
- I created a list alternating between my username (`wiener`) and the victim (`carlos`)
- My username appeared first
- Carlos’s username was repeated at least 100 times

For the password payload:
- I edited the candidate password list
- Inserted my own password (`peter`) before each candidate password
- Ensured the lists were aligned correctly

This caused every failed login attempt for Carlos to be **reset by a successful login to my account**.

---

### 4. Identifying the Correct Password
After running the attack:
- I filtered out all responses with **HTTP 200**
- Sorted the remaining results by username

Only one request for the username `carlos` returned an **HTTP 302**, indicating a successful login.

I noted the corresponding password from the payload.

---

### 5. Logging In
Using the identified password, I logged in as Carlos and accessed his account page, completing the lab.

---

## Why This Is a Server-Side Issue
The vulnerability exists because the backend:

- Resets brute-force counters after any successful login
- Tracks failed attempts globally instead of per user
- Relies on flawed authentication state logic

This allows attackers to brute-force passwords indefinitely.

---

## Key Takeaways
- Brute-force protection must be tied to the target account
- Successful logins should not reset counters for other users
- Logic flaws can fully defeat security controls
- Rate-limiting and lockout mechanisms must be carefully designed

---

## Impact
- Complete bypass of brute-force protection
- Unauthorized account access
- Increased risk of account compromise

---

## Why I’m Documenting This
I’m documenting this lab as:
- A personal learning reference
- Proof of hands-on experience with authentication logic flaws
- Preparation for interviews and real-world security testing
```

 

 
