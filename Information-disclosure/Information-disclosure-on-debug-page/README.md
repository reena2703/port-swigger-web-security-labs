# Information Disclosure – Debug Page Exposure

(**Web Security Academy**)

This lab demonstrates how **exposed debug functionality** can leak **high-impact secrets**, such as environment variables, that completely undermine application security.

---

## Lab: Information Disclosure on Debug Page

**Category:** Information disclosure
**Context:** Exploiting
**Level:** Apprentice
**Status:** Solved

---

## What This Lab Is About

The application contains a **publicly accessible debug page** that was never intended for end users. This page exposes:

* Internal configuration details
* Environment variables
* Sensitive secrets used by the application

The objective is to **locate the debug page** and extract the value of the `SECRET_KEY` environment variable.

---

## Initial Recon

1. Launched **Burp Suite**
2. Browsed to the **home page** of the lab
3. Allowed Burp to build the site map

---

## Discovering the Debug Page

### Finding Hidden Comments

1. Navigated to **Target → Site Map**
2. Right-clicked the top-level domain
3. Selected:

```
Engagement tools → Find comments
```

### Result

An HTML comment was discovered in the home page source referencing a **Debug** link:

```html
<!-- Debug: /cgi-bin/phpinfo.php -->
```

This strongly suggests the presence of an exposed diagnostic endpoint.

---

## Accessing the Debug Endpoint

1. Located `/cgi-bin/phpinfo.php` in the site map
2. Right-clicked the endpoint
3. Selected **Send to Repeater**
4. Sent the request

```http
GET /cgi-bin/phpinfo.php HTTP/1.1
```

---

## Information Disclosure Identified

The response contained a **full PHP debug page** showing:

* PHP configuration details
* Loaded modules
* Server variables
* **Environment variables**

Among them was the target value:

```text
SECRET_KEY=***************
```

This key is typically used for:

* Session signing
* Cryptographic operations
* Authentication logic

Its exposure represents a **critical security issue**.

---

## Submitting the Solution

1. Returned to the lab page
2. Clicked **Submit solution**
3. Entered the extracted `SECRET_KEY`
 

---

## Steps I Followed

1. Enabled Burp Proxy
2. Browsed the application normally
3. Used **Find comments** to identify hidden links
4. Discovered the debug endpoint
5. Accessed the debug page via Burp Repeater
6. Extracted the `SECRET_KEY` environment variable
7. Submitted the solution

---

## Why This Is Dangerous

Exposed debug pages can leak:

* Secret keys
* Database credentials
* API tokens
* File system paths
* Internal architecture details

If an attacker gains access to a `SECRET_KEY`, they may be able to:

* Forge session cookies
* Bypass authentication
* Escalate privileges
* Fully compromise the application

---

## Defensive Takeaways

To prevent this vulnerability:

* Disable debug pages in production
* Restrict access to diagnostic endpoints
* Remove sensitive comments from HTML
* Store secrets securely
* Never expose environment variables publicly

---

## Key Lesson

> **Debug functionality is effectively backdoor access if left exposed.**

Anything meant “only for developers” must be treated as **hostile surface area** in production.
 
