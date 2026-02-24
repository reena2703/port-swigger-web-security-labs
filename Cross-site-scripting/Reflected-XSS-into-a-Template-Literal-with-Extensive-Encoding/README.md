# Cross-Site Scripting (XSS) – Reflected XSS in JavaScript Template Literal
(Web Security Academy)

This lab demonstrates a **reflected cross-site scripting vulnerability** that occurs **inside a JavaScript template literal**.  
Even though many dangerous characters are encoded or escaped, **template expressions** can still be abused to execute JavaScript.

---

## Lab: Reflected XSS into a Template Literal with Extensive Encoding

**Category:** Cross-site scripting  
**Context:** JavaScript template literal  
**Type:** Reflected XSS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

This lab reflects user input from the **search functionality** into a **JavaScript template string**.

The application applies several defenses:

- Angle brackets (`< >`) HTML-encoded
- Single quotes (`'`) HTML-encoded
- Double quotes (`"`) HTML-encoded
- Backslashes (`\`) escaped
- Backticks (`` ` ``) Unicode-escaped

Despite these protections, **JavaScript execution is still possible** using template literal expressions.

---

## Vulnerable Flow

- **Source:** Search input (`location.search`)
- **Sink:** JavaScript template literal

The vulnerable code behaves like:

```js
const message = `Search results for: ${userInput}`;
````

---

## Key Observation

In JavaScript **template literals**:

* `${ ... }` is evaluated as JavaScript
* Encoding quotes or angle brackets does NOT stop expression execution
* Any valid JavaScript inside `${}` will run

---

## Payload Used

```js
${alert(1)}
```

---

## Steps I Followed

1. Entered a random alphanumeric string into the search box

2. Intercepted the request using **Burp Suite**

3. Sent the request to **Burp Repeater**

4. Observed that the input was reflected inside a JavaScript template literal

5. Replaced the input with:

   ```
   ${alert(1)}
   ```

6. Sent the modified request

7. Copied the resulting URL

8. Loaded the URL directly in the browser

9. The page executed the template expression

10. `alert(1)` was triggered

---

## Why This Worked

* Template literals evaluate `${}` expressions as JavaScript
* Encoding HTML characters does not neutralize JavaScript execution
* The application trusted user input inside a JavaScript execution context
* Context-aware encoding was incorrectly applied

---

## Impact

* Arbitrary JavaScript execution
* Reflected XSS (no user interaction required)
* Session hijacking
* DOM manipulation
* Client-side data exfiltration

---

## Key Lessons Learned

* JavaScript template literals are dangerous sinks
* Encoding characters is not enough for JavaScript contexts
* `${}` expressions execute regardless of HTML encoding
* Output encoding must match the **execution context**
* XSS defenses must consider **modern JavaScript features**

---

## Secure Coding Takeaways

To prevent this issue:

* Never embed untrusted input inside template literals
* Escape `${` sequences explicitly
* Avoid inline JavaScript with dynamic user input
* Use safe DOM APIs instead of string concatenation
* Enforce a strict Content Security Policy (CSP)

---

## Final Summary

* Reflected XSS vulnerability
* Occurs inside a JavaScript template literal
* Multiple encodings applied but ineffective
* `${}` expression allows JavaScript execution
* High-risk client-side vulnerability

 
