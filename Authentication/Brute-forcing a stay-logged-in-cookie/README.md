# PortSwigger Lab – Brute-Forcing a Stay-Logged-In Cookie

## Lab Details
Category: Server-Side Authentication (Other Mechanisms)  
Level: Practitioner  
Status: Solved   

---

## What This Lab Is About
This lab demonstrates a **server-side authentication vulnerability in a “stay logged in” feature**.

The application uses a persistent cookie to keep users logged in after the browser is closed. However, the cookie is **cryptographically weak and predictable**, allowing it to be brute-forced and reused to impersonate another user.

---

## Goal of the Lab
- Analyze the stay-logged-in cookie
- Brute-force Carlos’s cookie
- Access the **My account** page as Carlos

---

## Given Credentials
- My account: `wiener : peter`
- Victim username: `carlos`

---

## Tools Used
- Burp Suite
  - Proxy
  - Intruder
- Browser
- Candidate password wordlist

---

## How I Solved It

### 1. Analyzing the Stay-Logged-In Cookie
With Burp running, I logged in to my own account with **Stay logged in** enabled.

I observed that a cookie named:
```

stay-logged-in

```
was set.

After decoding the cookie from Base64, I got:
```

wiener:51dc30ddc473d43a6011e9ebba6ca770

```

The second value:
- Had a fixed length
- Used hexadecimal characters

This strongly suggested it was an **MD5 hash**.

I hashed my own password using MD5 and confirmed that the cookie format was:
```

base64(username + ":" + md5(password))

```

---

### 2. Preparing the Intruder Attack
I logged out and sent the most recent:
```

GET /my-account?id=wiener

```
request to **Burp Intruder**.

The `stay-logged-in` cookie was automatically set as a payload position.

I added my own password as a test payload and configured **Payload Processing** rules in this order:
1. Hash: MD5  
2. Add prefix: `wiener:`  
3. Encode: Base64  

---

### 3. Verifying Cookie Construction
To confirm the cookie was valid, I added a **Grep Match** rule for:
```

Update email

```

This button only appears when the user is authenticated.

The request successfully loaded my account page, confirming that the cookie construction logic was correct.

---

### 4. Brute-Forcing Carlos’s Cookie
I then modified the attack:
- Replaced my password with the **candidate password list**
- Changed the request URL to:
```

/my-account?id=carlos

```
- Updated the payload processing prefix to:
```

carlos:

```

After running the attack, only **one response** contained:
```

Update email

```

This payload was the valid stay-logged-in cookie for Carlos.

---

### 5. Accessing the Account
Using the identified cookie, I accessed Carlos’s **My account** page, completing the lab.

---

## Why This Is a Server-Side Issue
The vulnerability exists because the backend:

- Uses a predictable cookie format
- Relies on MD5, a weak hashing algorithm
- Does not bind cookies to sessions or devices
- Trusts client-side authentication tokens without proper protection

---

## Key Takeaways
- Persistent login cookies must be cryptographically strong
- MD5 should never be used for authentication
- Cookies should be random and server-validated
- Weak “remember me” features can lead to full account takeover

---

## Impact
- Account impersonation
- Full authentication bypass
- Long-term unauthorized access

---

## Why I’m Documenting This
I’m documenting this lab as:
- A personal learning record
- Proof of experience with authentication token flaws
- Demonstration of real-world brute-force techniques
- Preparation for interviews and security assessments
 
