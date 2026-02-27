# CSRF – Token Not Tied to User Session

(**Web Security Academy**)

This lab demonstrates a **flawed CSRF protection mechanism** where anti-CSRF tokens are implemented but **not bound to the user’s session**. As a result, a valid CSRF token issued to one user can be **reused by another user**, allowing a successful CSRF attack.

---

## Lab: CSRF Where Token Is Not Tied to User Session

**Category:** Cross-Site Request Forgery (CSRF)
**Protection Mechanism:** CSRF token (misconfigured)
**Difficulty:** Practitioner
**Tools Used:** Burp Suite Community Edition
**Status:** Solved

---

## What This Lab Is About

The application attempts to protect the **email change functionality** using CSRF tokens. However:

* CSRF tokens are **not bound to a specific user session**
* The server does **not verify token ownership**
* Any valid token can be reused by a different authenticated user

This breaks the fundamental security assumption of CSRF tokens.

---

## Target Functionality

Vulnerable endpoint:

```
POST /my-account/change-email
```

Parameters:

* `email`
* `csrf`

Although a CSRF token is required, the token is **not linked to the current session**.

---

## Vulnerable Flow

1. User A (attacker) obtains a valid CSRF token
2. User B (victim) is authenticated
3. Attacker forces User B’s browser to submit a request
4. Attacker’s CSRF token is accepted
5. Victim’s email address is changed

---

## Accounts Provided by the Lab

```
wiener:peter
carlos:montoya
```

These two accounts are used to demonstrate **token reuse across sessions**.

---

## Attack Strategy

The exploit works because:

* CSRF tokens are globally valid
* Tokens are **not tied to a session ID**
* The server only checks whether a token exists and is valid
* Token ownership is never verified

---

## Steps I Followed (Community Edition)

1. Logged in as **wiener**
2. Submitted the **Update Email** form
3. Intercepted the request in **Burp Proxy**
4. Noted the CSRF token value
5. Dropped the request (email unchanged)
6. Opened an **incognito window**
7. Logged in as **carlos**
8. Submitted the Update Email request
9. Sent the request to **Burp Repeater**
10. Replaced Carlos’s CSRF token with Wiener’s token
11. Sent the modified request
12. Server accepted the request
13. Confirmed Carlos’s email was changed
14. Crafted a CSRF exploit using a valid token
15. Hosted the exploit on the **exploit server**
16. Delivered the exploit to the victim
17. Lab marked as solved

---

## CSRF Exploit Payload

The exploit is identical to the **“no defenses” CSRF lab**, except it includes a **valid but foreign CSRF token**.

```html
<form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="csrf-session@web-security-academy.net">
    <input type="hidden" name="csrf" value="VALID_TOKEN_FROM_OTHER_USER">
</form>

<script>
    document.forms[0].submit();
</script>
```

---

## Why This Works

* The CSRF token is valid
* The server does not verify which user the token belongs to
* Session identity is ignored during CSRF validation
* Browser automatically includes victim’s session cookies

---

## Impact

An attacker can:

* Reuse stolen CSRF tokens
* Perform authenticated actions on other users
* Bypass CSRF protection entirely
* Chain with XSS or information disclosure

Severity: **High**

---

## Key Lessons Learned

* CSRF tokens must be **session-bound**
* Token presence alone is meaningless
* CSRF protection must validate **ownership**
* Community Edition is sufficient for CSRF exploitation
* Broken CSRF is often worse than no CSRF

---

## Defensive Takeaways

To prevent this vulnerability:

* Bind CSRF tokens to user sessions
* Invalidate tokens on logout
* Use SameSite cookies
* Validate Origin / Referer headers
* Rotate tokens per request

---

## Final Summary

* CSRF token present but misconfigured
* Token reusable across sessions
* Manual exploit built using Burp Suite Community Edition
* Victim’s email changed without consent
* Demonstrates **why CSRF tokens must be session-aware**

 
