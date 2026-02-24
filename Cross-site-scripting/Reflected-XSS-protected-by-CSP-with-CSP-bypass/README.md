# Cross-Site Scripting (XSS) – Reflected XSS with CSP Bypass

(**Web Security Academy**)

This lab demonstrates how a **misconfigured Content Security Policy (CSP)** can be abused to **bypass script execution restrictions**, even when reflected XSS is otherwise blocked.

---

## Lab: Reflected XSS Protected by CSP, with CSP Bypass

**Category:** Cross-site scripting
**Context:** CSP
**Type:** Reflected XSS
**Level:** Expert
**Status:** Solved
**Browser Requirement:** Chrome

---

## What This Lab Is About

This lab contains:

* A **reflected XSS vulnerability**
* A **Content Security Policy (CSP)** that blocks inline scripts
* A **CSP injection point** via a controllable parameter

Although the application reflects user input safely, a flaw in how CSP directives are constructed allows an attacker to **inject new CSP rules**, effectively disabling the protection.

The goal is to **bypass CSP** and successfully execute:

```js
alert(1)
```

---

## Initial Observation

Injecting a basic payload:

```html
<img src=1 onerror=alert(1)>
```

Results in:

* Payload reflected in the response  (yes)
* JavaScript execution blocked by CSP (no)

This confirms that:

* XSS exists
* CSP is actively preventing execution

---

## CSP Analysis

Using **Burp Proxy**, the response reveals a CSP header similar to:

```http
Content-Security-Policy: default-src 'self'; report-uri /csp-report?token=RANDOM
```

### Key Insight

* The `report-uri` directive contains a **token parameter**
* The token value is **fully user-controlled**
* CSP directives are **not sanitized**
* This allows **CSP injection**

---

## Vulnerable Flow

* **Source:** `token` query parameter
* **Sink:** Content-Security-Policy header
* **Impact:** Ability to inject new CSP directives

---

## Exploitation Strategy

Instead of bypassing CSP directly, the attack:

1. Injects a **new CSP directive**
2. Overrides existing script restrictions
3. Allows inline scripts to execute

This is done using the **`script-src-elem`** directive, which applies only to `<script>` elements.

---

## Final Exploit Payload

Visit the following URL (replace `YOUR-LAB-ID`):

```text
https://YOUR-LAB-ID.web-security-academy.net/?search=%3Cscript%3Ealert%281%29%3C%2Fscript%3E&token=;script-src-elem%20%27unsafe-inline%27
```

---

## Why This Works

* `token` is injected directly into the CSP header
* `;` terminates the existing directive
* `script-src-elem 'unsafe-inline'` is injected
* This **overrides the original CSP**
* Inline `<script>` tags are now allowed
* Reflected script executes successfully

---

## Steps I Followed

1. Injected a basic XSS payload
2. Confirmed execution was blocked by CSP
3. Inspected response headers in Burp
4. Identified controllable `token` parameter
5. Injected a new CSP directive using `;`
6. Enabled `unsafe-inline` for script elements
7. Injected inline `<script>alert(1)</script>`
8. Observed successful execution
9. Lab marked as solved

---

## Impact

* Complete CSP bypass
* Arbitrary JavaScript execution
* CSP rendered ineffective
* Demonstrates dangers of dynamic CSP construction

---

## Key Lessons Learned

* CSP is only as strong as its implementation
* User input must **never** be embedded in CSP headers
* CSP injection is as dangerous as XSS
* `script-src-elem` can override `script-src`
* Security headers require strict validation

---

## Defensive Takeaways

To prevent this vulnerability:

* Never include user input in CSP headers
* Use static, server-defined CSP values
* Avoid dynamic CSP construction
* Validate and encode all header values
* Monitor CSP violation reports carefully

---

## Final Summary

* Reflected XSS existed but was blocked by CSP
* CSP was injectable via a user-controlled parameter
* New CSP rules enabled inline scripts
* XSS payload executed successfully
* Shows how **CSP misconfiguration completely breaks XSS defenses**

 
