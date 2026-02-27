# CSRF – Token Duplicated in Cookie

(**Web Security Academy**)

This lab demonstrates a **flawed CSRF protection mechanism** that uses the **double submit cookie pattern**, but implements it **insecurely**.
Because the application only checks whether the CSRF token in the request body matches the value in a cookie—and does not bind either to the user’s session—an attacker can **inject a fake CSRF cookie** and fully bypass the protection.

---

## Lab: CSRF Where Token Is Duplicated in Cookie

**Category:** Cross-Site Request Forgery (CSRF)
**Protection Mechanism:** Double submit cookie (broken)
**Difficulty:** Practitioner
**Tools Used:** Burp Suite Community Edition
**Status:** Solved

---

## What This Lab Is About

The application attempts to prevent CSRF by:

* Storing a CSRF token in a cookie (`csrf`)
* Requiring the same value to be submitted as a request parameter

However:

* The token is **not tied to the user session**
* The server only checks **equality**, not authenticity
* The cookie can be **injected into the victim’s browser**

This makes the CSRF defense completely bypassable.

---

## Target Functionality

Vulnerable endpoint:

```http
POST /my-account/change-email
```

Parameters:

* `email`
* `csrf`

Cookie:

* `csrf`

---

## Key Observation

From Burp Repeater:

* Changing the CSRF body parameter alone → request rejected
* Changing both:

  * `csrf` cookie
  * `csrf` body parameter
    to the same value → request accepted

This confirms the application is using **insecure double submit validation**.

---

## Vulnerable Flow

1. Application compares `csrf` cookie and `csrf` parameter
2. No session binding or server-side token storage
3. Attacker injects a chosen `csrf` cookie
4. Attacker submits matching CSRF value in request
5. Server accepts the request
6. Victim’s email address is changed

---

## Exploitation Steps (Community Edition)

1. Logged in as `wiener:peter`
2. Submitted the Update Email form
3. Captured request in **Burp Proxy**
4. Sent request to **Repeater**
5. Observed CSRF validation relies only on equality
6. Performed a search request
7. Sent search request to Repeater
8. Observed reflected input in `Set-Cookie` header
9. Identified **HTTP response splitting vulnerability**
10. Crafted cookie injection payload
11. Built CSRF exploit using injected cookie
12. Delivered exploit to victim
13. Lab marked as solved

---

## Cookie Injection Payload

The search endpoint reflects user input into response headers, allowing cookie injection:

```text
/?search=test%0d%0aSet-Cookie:%20csrf=fake%3b%20SameSite=None
```

This forces the victim’s browser to store:

```text
csrf=fake
```

---

## Final CSRF Exploit Payload

```html
<form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="double-submit@web-security-academy.net">
    <input type="hidden" name="csrf" value="fake">
</form>

<img src="https://YOUR-LAB-ID.web-security-academy.net/?search=test%0d%0aSet-Cookie:%20csrf=fake%3b%20SameSite=None"
     onerror="document.forms[0].submit();">
```

---

## Why This Works

* CSRF token validation is client-controlled
* Cookie and body token are attacker-defined
* No session binding exists
* Cookie injection allows full token control
* Browser automatically includes session cookies

---

## Impact

An attacker can:

* Forge authenticated requests
* Bypass CSRF protections entirely
* Modify account details
* Abuse any state-changing endpoint

Severity: **High**

---

## Key Lessons Learned

* Double submit cookies are **dangerous if misused**
* CSRF tokens must be server-generated and session-bound
* Client-side validation ≠ security
* Header injection can completely break CSRF defenses
* Equality checks alone are insufficient

---

## Defensive Takeaways

To properly defend against this attack:

* Bind CSRF tokens to user sessions
* Store tokens server-side
* Never trust client-set cookies for validation
* Prevent CRLF / response splitting
* Use SameSite cookies as a defense-in-depth measure

---

## Final Summary

* CSRF token duplicated in cookie
* Token validation based on equality only
* Cookie injection via response splitting
* Manual exploit built using Burp Suite Community Edition
* Victim’s email changed without consent

 
