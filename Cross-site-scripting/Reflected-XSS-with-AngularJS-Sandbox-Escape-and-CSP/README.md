# Cross-Site Scripting (XSS) – AngularJS Sandbox Escape with CSP

(**Web Security Academy**)

This lab demonstrates an **advanced reflected XSS attack** that simultaneously **bypasses Content Security Policy (CSP)** and **escapes the AngularJS sandbox**, resulting in the execution of arbitrary JavaScript and disclosure of **`document.cookie`**.

---

## Lab: Reflected XSS with AngularJS Sandbox Escape and CSP

**Category:** Cross-site scripting
**Context:** Client-side template injection (AngularJS)
**Type:** Reflected XSS
**Protections Present:**

* Content Security Policy (CSP)
* AngularJS sandbox

**Difficulty:** Expert
**Status:** Solved

---

## What This Lab Is About

This lab combines **multiple defensive mechanisms**:

* A **strict CSP** blocking inline JavaScript
* AngularJS expression sandboxing
* No direct access to `window`
* Restricted function calls

Despite these protections, the application remains vulnerable due to:

* Unsafe AngularJS expression evaluation
* Event-based execution
* Browser-specific behavior (Chrome)

The objective is to **execute `alert(document.cookie)`** by:

* Bypassing CSP
* Escaping the AngularJS sandbox
* Avoiding direct references to restricted objects

---

## Vulnerable Flow

* **Source:** `search` query parameter
* **Sink:** AngularJS expression inside HTML
* **Trigger:** Focus event (`ng-focus`)
* **Sensitive Data:** `document.cookie`
* **Browser Dependency:** Chrome

---

## Key Constraints

This lab prevents:

* Inline `<script>` execution via CSP
* Direct access to `window`
* Simple AngularJS expression abuse

The exploit must rely on **AngularJS internals and event objects**.

---

## Exploit Payload

### Exploit Server Code

```html
<script>
location='https://YOUR-LAB-ID.web-security-academy.net/?search=%3Cinput%20id=x%20ng-focus=$event.composedPath()|orderBy:%27(z=alert)(document.cookie)%27%3E#x';
</script>
```

This payload is delivered via the **exploit server** and automatically executes when the victim loads the page.

---

## Steps I Followed

1. Identified AngularJS usage with CSP enabled
2. Confirmed inline JavaScript was blocked by CSP
3. Discovered AngularJS directives were still processed
4. Injected a custom `<input>` element with:

   * `ng-focus` directive
   * Controlled `id`
5. Used a URL fragment (`#x`) to auto-focus the element
6. Accessed the event object via `$event`
7. Used `$event.composedPath()` to retrieve the event path
8. Leveraged the AngularJS `orderBy` filter for execution
9. Assigned `alert` to a variable (`z`) instead of calling it directly
10. Triggered execution when the filter reached the `window` object
11. Successfully executed `alert(document.cookie)`
12. Lab marked as solved

---

## Why This Worked

### CSP Bypass

* CSP blocks inline scripts but **allows AngularJS directives**
* Event-driven execution (`ng-focus`) is not blocked

### AngularJS Sandbox Escape

* `$event` exposes the browser event object
* `composedPath()` (Chrome-specific) returns an array ending in `window`
* AngularJS does not properly restrict access through filter chains

### Execution Trick

* `|` is interpreted as an AngularJS filter, not JavaScript OR
* `orderBy:` accepts an expression as an argument
* Assigning `alert` to a variable delays execution
* Execution occurs only when the `window` object is reached

This bypasses AngularJS’s explicit `window` reference checks.

---

## Impact

* CSP protections bypassed
* AngularJS sandbox fully escaped
* Arbitrary JavaScript execution
* Session cookies disclosed
* High risk of account takeover

---

## Key Lessons Learned

* CSP does **not** protect against AngularJS expression injection
* Event objects can expose powerful browser internals
* Framework sandboxes are not security boundaries
* Browser-specific features can enable unexpected exploitation paths
* CSTI vulnerabilities can defeat multiple defense layers

---

## Defensive Takeaways

To mitigate this class of vulnerability:

* Avoid evaluating user input in AngularJS expressions
* Remove legacy AngularJS where possible
* Use strict CSP **and** eliminate template injection
* Disable dangerous AngularJS directives
* Treat CSTI as equivalent to full XSS

---

## Final Summary

* Reflected CSTI vulnerability exploited
* CSP bypassed using AngularJS directives
* Sandbox escape via `$event.composedPath()`
* `alert(document.cookie)` executed
* Demonstrates why AngularJS + CSP is not sufficient defense
 
