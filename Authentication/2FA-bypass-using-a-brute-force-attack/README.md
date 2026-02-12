# PortSwigger Lab – 2FA Bypass Using a Brute-Force Attack

## Lab Details
Category: Server-Side Authentication – Multi-Factor  
Level: Expert  
Status: Solved  

---

## Lab Description
This lab’s two-factor authentication mechanism is vulnerable to **brute-force attacks** due to missing rate limiting and flawed session handling.

Although valid credentials are required, the 2FA verification code can be brute-forced by abusing Burp’s **session handling rules and macros** to automatically re-authenticate before each attempt.

---

## Objective
- Brute-force the 4-digit 2FA code
- Maintain an authenticated session automatically
- Access Carlos’s *My account* page

---

## Victim Credentials
- Username: `carlos`
- Password: `montoya`

---

## Tools Used
- Burp Suite
  - Proxy
  - Intruder
  - Session Handling Rules
  - Macros

---

## Solution Walkthrough

### Step 1: Analyze the 2FA Flow
Logged in using Carlos’s credentials and inspected the 2FA verification process.

Observed that:
- Entering the wrong 2FA code **twice** logs the user out
- A valid session is required to submit each `/login2` request

This makes normal brute-force attacks impossible without automated re-authentication.

---

### Step 2: Create a Session Handling Rule
Opened **Burp Settings → Sessions** and added a new **Session Handling Rule**.

Scope:
- Included **all URLs**

This ensures the rule applies to every request sent by Burp tools.

---

### Step 3: Configure a Login Macro
Under **Rule Actions**, added **Run a macro** and recorded the following requests:

1. `GET /login`
2. `POST /login`
3. `GET /login2`

These requests fully authenticate Carlos and land on the 2FA verification page.

Tested the macro and confirmed the final response prompts for the 4-digit security code.

This macro now automatically logs Carlos back in **before every Intruder request**.

---

### Step 4: Send 2FA Request to Intruder
Sent the `POST /login2` request to **Burp Intruder**.

Added a payload position to the `mfa-code` parameter:

```

mfa-code=§0000§

```

---

### Step 5: Configure the Brute-Force Attack
Payload settings:
- Payload type: **Numbers**
- Range: `0 – 9999`
- Min / Max integer digits: `4`
- Step: `1`

This generates every possible 4-digit code.

---

### Step 6: Control Request Timing
Opened **Resource Pool** settings and set:
- Maximum concurrent requests: `1`

This ensures requests are sent sequentially and avoids breaking the session logic.

---

### Step 7: Identify the Correct Code
Started the Intruder attack.

Eventually, one request returned:
```

HTTP/1.1 302 Found

```

This indicates a successful 2FA verification.

---

### Step 8: Access the Account
Right-clicked the successful request and selected **Show response in browser**.

Loaded the URL and confirmed authentication as `carlos`.

Clicked **My account** to solve the lab.

---

## Impact
- 2FA brute-force vulnerability
- No rate limiting on verification codes
- Session logic can be abused for automation
- Full account takeover despite MFA

---

## Key Takeaways
- 2FA must implement strict rate limiting
- Verification attempts should be session-bound
- MFA codes must expire after limited attempts
- Burp macros are extremely powerful for real-world testing

 

 
