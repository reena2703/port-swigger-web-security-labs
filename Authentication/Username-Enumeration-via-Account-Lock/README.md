 # PortSwigger Lab – Username Enumeration via Account Lock

## Lab Details
Category: Server-Side Authentication (Password-Based)  
Level: Practitioner  
Status: Solved  

---

## What This Lab Is About
This lab demonstrates a **server-side authentication logic flaw in account lockout mechanisms**.

Although the application implements account locking after multiple failed login attempts, the backend **handles valid and invalid usernames differently**. This behavior leaks information that allows an attacker to enumerate valid usernames and then brute-force their passwords.

---

## Goal of the Lab
- Enumerate a valid username using account lock behavior
- Brute-force the password for that user
- Log in and access the account page

---

## Tools Used
- Burp Suite
  - Proxy
  - Intruder (Cluster Bomb & Sniper attacks)
- Provided username wordlist
- Provided password wordlist

---

## How I Solved It

### 1. Intercepting the Login Request
With Burp running, I submitted an invalid username and password and sent the `POST /login` request to **Burp Intruder**.

---

### 2. Enumerating a Valid Username via Account Lock
I configured a **Cluster Bomb attack** with two payload positions:

```

username=§invalid-username§&password=example§§

```

Payload configuration:
- Payload 1 (username): candidate usernames
- Payload 2: Null payloads (5 payloads per username)

This caused each username to be tested multiple times, triggering the account lock behavior.

After running the attack, I noticed that:
- One username produced **longer responses**
- The error message was different:
```

You have made too many incorrect login attempts.

```

This indicated a **real account**, which I noted down.

---

### 3. Brute-Forcing the Password
I created a new Intruder attack using **Sniper** mode.

- Fixed the username to the identified valid user
- Added a payload position to the `password` parameter
- Loaded the candidate password list
- Configured **Grep - Extract** to extract error messages

After running the attack, I observed:
- Most responses contained error messages
- One response contained **no error message**

This indicated a successful login attempt. I noted the password.

---

### 4. Logging In
After waiting for the account lock to reset, I logged in using the identified username and password and accessed the account page, completing the lab.

---

## Why This Is a Server-Side Issue
The vulnerability exists because the backend:

- Applies account lock logic inconsistently
- Treats valid and invalid usernames differently
- Leaks authentication state through error messages
- Does not standardize lockout responses

---

## Key Takeaways
- Account lock mechanisms can leak sensitive information
- Error messages must remain consistent
- Repeated login behavior can be abused for enumeration
- Defensive features can introduce new attack surfaces

---

## Impact
- Username enumeration despite account locking
- Targeted password brute-force attacks
- Increased risk of account compromise

---

## Why I’m Documenting This
I’m documenting this lab as:
- A personal learning reference
- Proof of hands-on experience with authentication logic flaws
- Demonstration of real-world enumeration techniques
- Preparation for interviews and security assessments
 
