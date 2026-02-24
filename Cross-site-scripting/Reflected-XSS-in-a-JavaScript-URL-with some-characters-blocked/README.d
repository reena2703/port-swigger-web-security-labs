# Cross-Site Scripting (XSS) – Reflected XSS in a JavaScript URL with Character Restrictions

(**Web Security Academy**)

This lab demonstrates an **advanced reflected XSS vulnerability** where user input is embedded inside a **JavaScript URL**, but **key characters are blocked** to prevent trivial exploitation. Despite these restrictions, JavaScript execution is still possible using **exception handling and type coercion abuse**.

---

## Lab: Reflected XSS in a JavaScript URL with Some Characters Blocked

**Category:** Cross-site scripting
**Context:** JavaScript URL
**Type:** Reflected XSS
**Difficulty:** Expert
**Status:** Solved

---

## What This Lab Is About

At first glance, this lab appears trivial because user input is reflected into a `javascript:` URL. However, the application applies **character filtering** to block common attack patterns, including:

* Spaces
* Parentheses
* Direct function invocation
* Straightforward JavaScript expressions

The challenge is to **execute `alert()`** while ensuring the number **`1337` appears somewhere in the alert message**, despite these restrictions.

---

## Vulnerable Flow

* **Source:** URL query parameters
* **Sink:** `javascript:` URL execution
* **Execution Trigger:** User clicks **“Back to blog”**
* **Context:** JavaScript URL evaluation

---

## Key Constraints

* Spaces are blocked
* Some punctuation is blocked
* Standard function calls are not possible
* Payload must include the value `1337`
* Execution only occurs when the user clicks a navigation link

---

## Final Exploit URL

```text
https://YOUR-LAB-ID.web-security-academy.net/post?postId=5&'},x=x=>{throw/**/onerror=alert,1337},toString=x,window+'',{x:'
```

>  **Note:**
> The alert is only triggered after clicking **“Back to blog”** at the bottom of the page.

---

## How the Exploit Works

This payload abuses **JavaScript exception handling**, **arrow functions**, and **type coercion** to execute code without relying on blocked characters.

### Key Techniques Used

#### 1. Exception Handling (`throw`)

The payload uses:

```js
throw onerror=alert,1337
```

* Assigns `alert` to the global `onerror` handler
* Passes `1337` as the error argument
* Triggers `alert(1337)`

#### 2. Comment-Based Space Bypass

```js
throw/**/onerror=alert
```

* `/**/` acts as a space substitute
* Bypasses filters that block literal spaces

#### 3. Arrow Functions for Statement Execution

* `throw` is a **statement**, not an expression
* Arrow functions allow us to create a block where `throw` is valid

```js
x = x => { throw ... }
```

#### 4. `toString` Abuse

```js
toString = x
window + ''
```

* Assigns the malicious function to `toString`
* Forces JavaScript to coerce `window` into a string
* This automatically invokes `toString()`
* The exception is thrown during coercion
* `onerror` executes `alert(1337)`

---

## Steps I Followed

1. Identified that input was reflected inside a JavaScript URL
2. Tested standard payloads and confirmed character restrictions
3. Noted that:

   * Spaces were blocked
   * Direct function calls failed
4. Used comments (`/**/`) to bypass space filtering
5. Used arrow functions to allow `throw` execution
6. Assigned the payload to `window.toString`
7. Forced type coercion using `window + ''`
8. Clicked **“Back to blog”**
9. The browser raised an exception
10. `onerror` executed `alert(1337)`
11. Lab marked as solved

---

## Why This Worked

* JavaScript URLs execute in a privileged context
* Filters focused on syntax, not semantics
* Exception handling provides an alternate execution path
* `toString` coercion is implicit and hard to block
* Arrow functions bypass expression-only limitations

---

## Impact

* JavaScript execution despite heavy filtering
* Demonstrates that character blacklists are ineffective
* Shows how non-obvious language features can be weaponized

---

## Key Lessons Learned

* Blocking characters does **not** secure JavaScript contexts
* JavaScript has many implicit execution paths
* Exception handling is a powerful exploitation primitive
* Type coercion can trigger attacker-controlled code
* Blacklist-based defenses are fundamentally broken

---

## Defensive Takeaways

To prevent this class of vulnerability:

* Never embed user input in `javascript:` URLs
* Avoid client-side execution contexts entirely
* Use strict allowlists, not blacklists
* Apply proper contextual output encoding
* Enforce a strong Content Security Policy (CSP)

---

## Final Summary

* Reflected XSS via JavaScript URL
* Character restrictions bypassed using:

  * Arrow functions
  * Exception handling
  * `toString` coercion
* `alert(1337)` executed on user interaction
* Demonstrates expert-level XSS filter bypass

 
