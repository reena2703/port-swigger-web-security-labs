 
# PortSwigger Lab – 2FA Broken Logic

## Lab Details
Category: Server-Side Authentication (Multi-Factor Authentication)  
Level: Practitioner  
Status: Solved ✅  

---

## What This Lab Is About
This lab demonstrates a **server-side logic flaw in a two-factor authentication (2FA) implementation**.

Although the application uses a second authentication factor, the backend **incorrectly trusts a user-controlled parameter** to determine which account the 2FA verification applies to. This allows an attacker to generate and brute-force a valid 2FA code for another user.

---

## Goal of the Lab
- Exploit the broken 2FA logic
- Access Carlos’s account page without legitimate authorization

---

## Given Credentials
- My account: `wiener : peter`
- Victim username: `carlos`

---

## Tools Used
- Burp Suite
  - Proxy
  - Repeater
  - Intruder
- Built-in email client (for observing normal 2FA behavior)

---

## How I Solved It

### 1. Analyzing the 2FA Flow
With Burp running, I logged in to my own account and observed the 2FA verification process.

I noticed that the `POST /login2` request included a parameter named:
```

verify

```

This parameter determines **which user’s account** the 2FA verification applies to.

---

### 2. Forcing 2FA Code Generation for the Victim
After logging out, I sent the `GET /login2` request to **Burp Repeater**.

I modified the `verify` parameter to:
```

verify=carlos

```

Sending this request caused the server to generate a **temporary 2FA code for Carlos**.

---

### 3. Triggering the 2FA Verification Step
I returned to the login page and logged in using my own username and password.

When prompted for the 2FA code, I submitted an **invalid code** to reach the verification request.

---

### 4. Brute-Forcing the 2FA Code
I sent the `POST /login2` request to **Burp Intruder**.

Configuration:
- Fixed the `verify` parameter to `carlos`
- Added a payload position to the `mfa-code` parameter
- Brute-forced the verification code

After running the attack, one request returned an **HTTP 302** response.

---

### 5. Accessing the Account
I loaded the 302 response in the browser and clicked **My account**, successfully accessing Carlos’s account and completing the lab.

---

## Why This Is a Server-Side Issue
The vulnerability exists because the backend:

- Trusts a user-controlled parameter to identify the account
- Does not bind the 2FA process to the authenticated session
- Allows generation and validation of 2FA codes for other users

This completely breaks the security guarantees of multi-factor authentication.

---

## Key Takeaways
- 2FA must be tied to the authenticated session
- User-controlled parameters should never define identity
- MFA logic flaws can be worse than no MFA at all
- Server-side validation is critical for authentication flows

---

## Impact
- Full bypass of multi-factor authentication
- Unauthorized account access
- False sense of security for users

---

## Why I’m Documenting This
I’m documenting this lab as:
- A personal learning record
- Proof of hands-on experience with broken MFA logic
- Preparation for interviews and real-world security assessments
 
