# CSRF – SameSite Lax Bypass via Method Override

(**Web Security Academy**)

This lab demonstrates how **SameSite=Lax cookies can be bypassed** when an application supports **HTTP method override**.
Although SameSite cookies are enabled by default, flawed server-side logic allows a **cross-site GET request** to be interpreted as a **POST**, resulting in a successful CSRF attack.

---

## Lab: SameSite Lax Bypass via Method Override

**Category:** Cross-Site Request Forgery (CSRF)
**Protection Mechanism:** SameSite cookies (default Lax)
**Difficulty:** Practitioner
**Tools Used:** Burp Suite Community Edition
**Status:** Solved

---

## What This Lab Is About

The application attempts to rely on **SameSite=Lax cookies** for CSRF protection. However:

* No CSRF token is implemented
* The server supports `_method=POST`
* SameSite=Lax cookies are sent on **cross-site top-level GET requests**

This combination allows an attacker to bypass CSRF protections entirely.

---

## Target Functionality

Vulnerable endpoint:

```http
POST /my-account/change-email
```

Parameters:

* `email`

There is **no CSRF token** protecting this request.

---

## Key Observations

### 1. No CSRF Token

The email change request contains no unpredictable value, making it vulnerable if cookies are included.

### 2. Default SameSite=Lax Cookies

The session cookie is set **without explicitly specifying SameSite**, so browsers apply:

```
SameSite=Lax
```

This means:

* Cookies are **not** sent with cross-site POST requests
* Cookies **are** sent with cross-site **top-level GET navigations**

---

## Exploitation Strategy

### Step 1: Identify Method Override

In Burp Repeater:

* Converted the POST request to GET
* Added `_method=POST` as a query parameter

```http
GET /my-account/change-email?email=test@web-security-academy.net&_method=POST
```

**Result:**
The server accepted the request and changed the email address.

This confirms the backend honors the `_method` parameter.

---

## Attack Flow

1. Victim logs in
2. Victim visits attacker-controlled page
3. Browser performs a top-level navigation
4. SameSite=Lax session cookie is included
5. GET request contains `_method=POST`
6. Server treats request as POST
7. Email address is changed
8. CSRF attack succeeds

---

## CSRF Exploit Payload

Hosted on the exploit server:

```html
<script>
    document.location =
        "https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email" +
        "?email=csrf-bypass@web-security-academy.net&_method=POST";
</script>
```

---

## Why This Works

* SameSite=Lax allows cookies on top-level GET requests
* JavaScript navigation triggers a top-level request
* Method override converts GET into POST server-side
* No CSRF token is validated
* Server blindly trusts authenticated requests

---

## Verification & Delivery

1. Stored the exploit on the exploit server
2. Clicked **View exploit** to confirm email change
3. Modified the email value to avoid matching my own
4. Clicked **Deliver exploit to victim**
5. Lab marked as **Solved**

---

## Impact

An attacker can:

* Perform authenticated state-changing actions
* Bypass SameSite cookie protections
* Exploit method override logic
* Execute CSRF attacks reliably

**Severity:** High

---

## Key Lessons Learned

* SameSite=Lax is **not sufficient** as a standalone CSRF defense
* Method override features are dangerous if unrestricted
* CSRF tokens remain essential
* Top-level navigations are powerful attack vectors

---

## Defensive Takeaways

To prevent this vulnerability:

* Implement CSRF tokens on all state-changing requests
* Disable or strictly control method override mechanisms
* Enforce HTTP method checks server-side
* Explicitly set `SameSite=Strict` where possible
* Use layered CSRF defenses

---

## Final Summary

* No CSRF token on email change
* Default SameSite=Lax cookies in use
* Method override enabled
* GET request abused to perform POST action
* CSRF successfully executed via top-level navigation
* Exploit built using Burp Suite Community Edition

 
