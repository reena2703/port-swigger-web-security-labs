# PortSwigger Lab – 2FA Simple Bypass

## Lab Details
Category: Server-Side Authentication (Multi-factor Authentication)  
Level: Apprentice  
Status: Solved   

---

## What This Lab Is About
This lab demonstrates a **server-side flaw in two-factor authentication (2FA)** where the application fails to properly enforce the second authentication step.

Although the application uses 2FA, the backend does **not verify whether the second factor was actually completed** before allowing access to sensitive pages. This makes it possible to bypass 2FA entirely.

The issue exists on the **server side**, not the frontend.

---

## Goal of the Lab
- Bypass the 2FA verification step
- Access Carlos’s account page without a valid 2FA code

---

## Given Credentials
- My account: `wiener : peter`
- Victim account: `carlos : montoya`

---

## Tools Used
- Browser
- Burp Suite (for observing behavior, not required for exploitation)
- Built-in email client (for testing normal 2FA flow)

---

## How I Solved It

### 1. Understanding the Normal 2FA Flow
I first logged in using my own credentials (`wiener:peter`).

- After entering the username and password, the application prompted for a 2FA code.
- The verification code was sent via email.
- After entering the code, I was redirected to my account page.

I noted the URL of the account page:
```

/my-account

```

---

### 2. Logging in as the Victim
Next, I logged out and logged in using the victim’s credentials:
```

carlos : montoya

```

As expected, the application prompted for a 2FA verification code, which I did not have access to.

---

### 3. Bypassing 2FA
Instead of entering a verification code, I manually changed the URL in the browser to:
```

/my-account

```

The page loaded successfully, and I was able to access Carlos’s account **without completing 2FA**, solving the lab.

---

## Why This Is a Server-Side Issue
The vulnerability exists because the backend:

- Does not enforce completion of the 2FA step
- Allows direct access to protected endpoints
- Fails to verify session state before granting access

The server assumes that reaching `/my-account` means authentication is complete, which is incorrect.

---

## Key Takeaways
- 2FA must be enforced **server-side**, not just via UI flow
- Sensitive endpoints should always verify authentication state
- Relying on URL flow instead of backend checks leads to bypasses
- 2FA is useless if it can be skipped

---

## Impact
- Complete bypass of multi-factor authentication
- Unauthorized access to user accounts
- False sense of security for users and developers

---

## Why I’m Documenting This
I’m documenting this lab as:
- A personal learning reference
- Proof of hands-on experience with server-side authentication flaws
- Preparation for interviews and real-world security assessments
```

 
