# Cross-Site Scripting (XSS) – AngularJS Sandbox Escape Without Strings

(**Web Security Academy**)

This lab demonstrates an **advanced client-side template injection (CSTI)** vulnerability in **AngularJS**, where an attacker escapes the AngularJS sandbox **without using strings or `$eval`**, leading to arbitrary JavaScript execution.

---

## Lab: Reflected XSS with AngularJS Sandbox Escape Without Strings

**Category:** Cross-site scripting
**Context:** Client-side template injection (AngularJS)
**Type:** Reflected XSS
**Framework:** AngularJS
**Difficulty:** Expert
**Status:** Solved

---

## What This Lab Is About

This lab uses AngularJS in a **non-standard, hardened configuration**:

* `$eval` is **not available**
* **Strings are completely disallowed**
* Input is evaluated inside an AngularJS expression
* The AngularJS sandbox attempts to prevent access to dangerous APIs

Despite these restrictions, the lab can still be exploited by abusing **JavaScript prototype manipulation** and **AngularJS filters**.

The goal is to **escape the AngularJS sandbox and execute `alert(1)` without using strings**.

---

## Vulnerable Flow

* **Source:** `search` URL parameter
* **Sink:** AngularJS expression evaluation
* **Context:** Client-side template rendering
* **Protection:** AngularJS sandbox (incomplete)

---

## Key Constraints

This lab explicitly prevents:

* Using string literals (`"`, `'`, `` ` ``)
* Using `$eval`
* Direct function invocation with string arguments

This forces a **pure JavaScript object-oriented exploitation approach**.

---

## Payload Used

```text
1&toString().constructor.prototype.charAt=[].join;
[1]|orderBy:toString().constructor.fromCharCode(120,61,97,108,101,114,116,40,49,41)=1
```

### Full Exploit URL

```text
https://YOUR-LAB-ID.web-security-academy.net/?search=1&toString().constructor.prototype.charAt%3d[].join;[1]|orderBy:toString().constructor.fromCharCode(120,61,97,108,101,114,116,40,49,41)=1
```

---

## Steps I Followed

1. Identified that user input is evaluated inside an AngularJS expression
2. Confirmed that:

   * `$eval` is unavailable
   * String literals are blocked
3. Used `toString()` to generate strings **without quotes**
4. Accessed the `String` constructor via:

   ```
   toString().constructor
   ```
5. Overwrote `String.prototype.charAt` with `Array.prototype.join`
6. Passed an array into the AngularJS `orderBy` filter
7. Used `fromCharCode()` to generate JavaScript code dynamically
8. Constructed the string:

   ```
   x=alert(1)
   ```
9. Triggered execution due to the broken sandbox
10. `alert(1)` executed successfully
11. Lab marked as solved

---

## Why This Worked

* AngularJS sandbox relies on **blacklisting**, not true isolation
* Prototype manipulation affects **all strings globally**
* Overwriting `charAt` bypasses AngularJS safety checks
* `fromCharCode()` allows string creation without literals
* AngularJS filters (`orderBy`) can be abused as execution gadgets

Once the prototype chain is compromised, **AngularJS security assumptions collapse**.

---

## Impact

* Full sandbox escape
* Arbitrary JavaScript execution
* XSS despite:

  * No strings
  * No `$eval`
  * Restricted expression environment
* Complete client-side trust violation

---

## Key Lessons Learned

* Client-side sandboxes are extremely fragile
* Prototype pollution is a powerful exploitation technique
* Blocking strings is **not** sufficient protection
* AngularJS expressions can be abused in unexpected ways
* CSTI vulnerabilities can be as dangerous as classic XSS

---

## Defensive Takeaways

To prevent this class of attack:

* Avoid client-side template evaluation of user input
* Do not rely on AngularJS sandbox for security
* Upgrade or remove legacy AngularJS applications
* Enforce strong Content Security Policy (CSP)
* Treat CSTI as **high severity**

---

## Final Summary

* Reflected CSTI vulnerability in AngularJS
* Sandbox escape without strings or `$eval`
* JavaScript prototype manipulation abused
* Arbitrary JavaScript executed
* Demonstrates why AngularJS sandboxing is unsafe by design

 
