# CSRF – Token Validation Depends on Request Method

(**Web Security Academy**)

This lab demonstrates how **incomplete CSRF protections** can be bypassed when an application **validates CSRF tokens only for specific HTTP methods**, leaving other methods unprotected.

---

## Lab: CSRF Where Token Validation Depends on Request Method

**Category:** Cross-Site Request Forgery (CSRF)
**Technique:** CSRF token bypass
**Level:** Practitioner
**Status:** Solved

---

## What This Lab Is About

The application implements CSRF protection on the **email change functionality**, but the protection is flawed:

* CSRF tokens are validated for **POST requests**
* CSRF tokens are **not validated for GET requests**

This inconsistency allows an attacker to:

* Forge a cross-site request
* Change a victim’s email address
* Bypass CSRF defenses entirely

The goal is to **host a malicious HTML page** that silently changes the victim’s email when they view it.

---

## Target Functionality

The vulnerable endpoint:

```text
/my-account/change-email
```

Expected parameters:

* `email`
* `csrf` (only enforced for POST requests)

---

## Vulnerable Logic

| Request Method | CSRF Token Checked |
| -------------- | ------------------ |
| POST           |  Yes               |
| GET            |  No                |

Because browsers can easily issue **cross-site GET requests**, this creates a classic CSRF vulnerability.

---

## Discovery Process

1. Logged in using the provided credentials:

   ```
   wiener:peter
   ```

2. Changed the email address normally

3. Captured the request in **Burp Proxy**

4. Sent the request to **Burp Repeater**

5. Observed:

   * Modifying the CSRF token caused rejection (POST)

6. Converted the request method from **POST → GET**

7. Observed:

   * The request succeeded **without validating the CSRF token**

This confirmed the vulnerability.

---

## CSRF Exploit Payload

The following HTML was used to exploit the flaw:

```html
<form action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="anything@web-security-academy.net">
</form>

<script>
    document.forms[0].submit();
</script>
```

### Key Points

* Uses a **GET request**
* No CSRF token included
* Auto-submits when loaded
* Executes in the victim’s authenticated session

---

## Exploitation Steps

1. Logged in as `wiener`
2. Identified the vulnerable endpoint
3. Confirmed CSRF token enforcement only on POST
4. Crafted a GET-based CSRF exploit
5. Hosted the exploit on the **exploit server**
6. Tested the exploit locally using **View exploit**
7. Changed the email value to avoid matching my own
8. Delivered the exploit to the victim
9. Victim’s email was changed automatically
10. Lab marked as solved

---

## Why This Worked

* CSRF protection was **method-dependent**
* GET requests were trusted without verification
* Browsers automatically include session cookies
* Same-origin policy does **not** prevent CSRF
* No SameSite cookie protection was enforced

---

## Impact

An attacker can:

* Modify account data
* Perform unauthorized state-changing actions
* Abuse authenticated user sessions
* Bypass CSRF protections completely

This is a **high-impact CSRF vulnerability**.

---

## Key Lessons Learned

* CSRF tokens must be validated on **all state-changing requests**
* GET requests should never modify application state
* Partial CSRF defenses are ineffective
* Browsers are dangerous when trust assumptions are wrong

---

## Defensive Takeaways

To prevent this attack:

* Enforce CSRF validation on **all HTTP methods**
* Restrict state changes to POST/PUT/PATCH
* Implement `SameSite` cookies
* Reject unauthenticated or token-less requests
* Apply defense-in-depth (CSRF + origin checks)

---

## Final Summary

* CSRF token validated only for POST requests
* GET request bypassed all protections
* Malicious HTML auto-submitted request
* Victim’s email changed without consent
* Demonstrates how **incomplete CSRF defenses fail**

 
