# PortSwigger Lab – Username Enumeration via Response Timing

## Lab Details
Category: Server-Side Authentication (Password-Based)  
Level: Practitioner  
Status: Solved   

---

## What This Lab Is About
This lab demonstrates a **server-side authentication vulnerability based on response timing**.

Although the application uses generic error messages and IP-based brute-force protection, the backend processes valid and invalid usernames differently. These differences cause measurable variations in response time, which can be exploited to enumerate valid usernames and brute-force passwords.

---

## Goal of the Lab
- Enumerate a valid username using response timing differences
- Brute-force the password for that user
- Log in and access the account page

---

## Given Credentials
- My account: `wiener : peter`

---

## Tools Used
- Burp Suite
  - Proxy
  - Repeater
  - Intruder (Pitchfork attack)
- Provided username wordlist
- Provided password wordlist

---

## How I Solved It

### 1. Observing Response Timing Behavior
With Burp running, I submitted invalid login attempts and sent the `POST /login` request to **Burp Repeater**.

While testing different usernames and passwords, I noticed:
- The application blocks my IP after multiple failed attempts
- The `X-Forwarded-For` header is supported, allowing IP spoofing and bypass of the IP-based protection

---

### 2. Identifying Timing Differences
I continued testing login requests while paying close attention to **response times**.

I observed that:
- Invalid usernames returned responses in roughly the same amount of time
- Valid usernames caused a **longer response time**
- The response time increased further when a very long password was used

This confirmed that the backend performs additional processing when a username exists.

---

### 3. Enumerating a Valid Username
I sent the login request to **Burp Intruder** and configured a **Pitchfork attack**.

Setup:
- Added the `X-Forwarded-For` header
- Payload position 1: `X-Forwarded-For` (spoofed IP using numbers 1–100)
- Payload position 2: `username` (candidate usernames)
- Password set to a very long string (~100 characters)

I enabled the **Response received** and **Response completed** columns.

After running the attack, one username consistently produced a **significantly longer response time**, confirming it as valid.

---

### 4. Brute-Forcing the Password
I created a new Intruder attack using:
- Payload position 1: `X-Forwarded-For` (spoofed IPs)
- Payload position 2: `password` (candidate passwords)
- Username fixed to the identified valid user

After running the attack, one request returned an **HTTP 302** response.

This indicated a successful login, and I noted the password.

---

### 5. Logging In
Using the identified username and password, I logged in through the normal login page and accessed the account page, completing the lab.

---

## Why This Is a Server-Side Issue
The vulnerability exists because the backend:

- Performs additional checks for valid usernames
- Leaks information through response timing
- Relies on IP-based brute-force protection that can be bypassed
- Does not normalize processing time for authentication failures

---

## Key Takeaways
- Response timing is a valuable side-channel
- Generic error messages alone are not enough
- IP-based protections can often be bypassed
- Authentication logic must be constant-time where possible

---

## Impact
- Username enumeration without visible response differences
- Efficient, targeted brute-force attacks
- Increased risk of account compromise

---

## Why I’m Documenting This
I’m documenting this lab as:
- A personal learning record
- Proof of experience with timing-based attacks
- Demonstration of advanced server-side authentication testing
- Preparation for interviews and real-world security work
```

 
