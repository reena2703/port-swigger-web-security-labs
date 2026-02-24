# Information Disclosure – Authentication Bypass via Information Disclosure

(**Web Security Academy**)

This lab demonstrates how **information disclosure combined with trust in client-supplied headers** can lead to a **full authentication bypass** and **administrative access**.

---

## Lab: Authentication Bypass via Information Disclosure

**Category:** Information disclosure
**Context:** Exploiting
**Level:** Apprentice
**Status:** Solved

---

## What This Lab Is About

The application includes an **admin interface** that is protected by access controls. However:

* The server **trusts a custom HTTP header** to determine whether a request originates from `localhost`
* The name of this header is **disclosed via server behavior**
* Once identified, the header can be **spoofed by an attacker**

The goal is to:

1. Discover the custom header
2. Bypass authentication
3. Access the admin panel
4. Delete the user **carlos**

---

## Initial Recon

Attempting to access the admin panel directly:

```text
GET /admin
```

Result:

* Access denied
* Response indicates that `/admin` is accessible only if:

  * The user is an administrator **or**
  * The request originates from a **local IP address**

This strongly suggests **IP-based access control**.

---

## Information Disclosure via TRACE Method

To gather more information, the same endpoint was requested using the `TRACE` method:

```text
TRACE /admin
```

### Why TRACE?

* TRACE reflects the **full request** as seen by the server
* This can expose **hidden or injected headers**

---

## Header Disclosure

The TRACE response revealed a previously unknown header:

```text
X-Custom-IP-Authorization: <client-ip>
```

This indicates that:

* The front-end automatically adds this header
* The back-end trusts it to determine whether the request is from `localhost`
* The header can likely be **spoofed**

This is the key information disclosure that enables the attack.

---

## Exploiting the Authentication Bypass

### Step 1: Configure Burp Match & Replace

In **Burp Suite**:

1. Go to **Proxy → Match and Replace**
2. Click **Add**
3. Configure the rule as follows:

* **Type:** Request header
* **Match:** *(leave empty)*
* **Replace:**

```text
X-Custom-IP-Authorization: 127.0.0.1
```

4. Click **Test** to confirm the header is injected
5. Click **OK** to enable the rule

Burp now automatically injects this header into every request.

---

### Step 2: Access the Admin Panel

With the spoofed header in place:

* Browsed to the home page
* Navigated to `/admin`

Access granted — authentication successfully bypassed

---

## Privilege Escalation

Inside the admin interface:

* Located the user management section
* Deleted the user **carlos**

The lab was immediately marked as **solved**.

---

## Steps I Followed

1. Attempted to access `/admin`
2. Observed IP-based access control
3. Sent a `TRACE /admin` request
4. Discovered `X-Custom-IP-Authorization` header
5. Configured Burp to inject `127.0.0.1`
6. Revisited the admin panel
7. Deleted user `carlos`
8. Completed the lab

---

## Why This Worked

* The application trusted a **client-controlled HTTP header**
* The header name was **leaked via TRACE**
* No server-side validation ensured the header was legitimate
* IP-based trust was implemented incorrectly

This breaks the core security principle:

> **Never trust data supplied by the client**

---

## Impact

An attacker can:

* Bypass authentication entirely
* Gain administrator privileges
* Perform destructive actions
* Delete users
* Potentially take over the application

---

## Defensive Takeaways

To prevent this vulnerability:

* Disable the TRACE method
* Never trust client-supplied IP headers
* Enforce authentication server-side
* Validate access based on session state, not headers
* Restrict admin interfaces properly
* Avoid IP-based authentication logic

---

## Key Lesson

> **Information disclosure often turns “low risk” issues into full compromises.**

A single leaked header name was enough to break authentication completely.

 
