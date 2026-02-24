# Cross-Site Scripting (XSS) – Stored DOM XSS
(Web Security Academy)

Stored DOM XSS is a **client-side vulnerability** where malicious input is stored by the application and later processed insecurely by JavaScript in the victim’s browser.

Unlike classic stored XSS, the payload is **not directly executed by the server response**, but instead by unsafe DOM manipulation logic.

---

## Lab: Stored DOM XSS

**Category:** Cross-site scripting  
**Type:** Stored DOM-based XSS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

This lab demonstrates a stored DOM XSS vulnerability in the blog comment feature where:

- User input is stored server-side
- The stored input is later processed by client-side JavaScript
- JavaScript attempts to sanitize angle brackets using `replace()`
- The sanitization logic is flawed
- HTML injection is still possible

---

## Vulnerable Flow

- **Source:** Blog comment input (stored)
- **Processing:** Client-side JavaScript `replace()` filter
- **Sink:** DOM rendering (HTML parsing in the browser)

The application uses logic similar to:

```js
comment = comment.replace("<", "&lt;").replace(">", "&gt;");
````

Because `replace()` is called with **string arguments**, it only replaces the **first occurrence** of each character.

---

## Payload Used

```html
<><img src=1 onerror=alert(1)>
```

---

## Steps I Followed

1. Opened a blog post
2. Submitted a comment containing the payload:

   ```
   <><img src=1 onerror=alert(1)>
   ```
3. The application attempted to sanitize angle brackets
4. Only the **first** `<` and `>` were encoded
5. Remaining angle brackets were left intact
6. The `<img>` tag was rendered in the DOM
7. The invalid image source triggered `onerror`
8. `alert(1)` executed successfully

---

## Why This Worked

* The application relied on `replace()` with string arguments
* `replace()` only affects the **first match**
* Extra angle brackets were used to bypass the filter
* HTML was still parsed by the browser
* Event handlers (`onerror`) allowed JavaScript execution

---

## Impact

* Persistent JavaScript execution
* Affects all users viewing the comment
* Session hijacking
* Credential theft
* Client-side account takeover

---

## Key Lessons Learned

* Stored DOM XSS is triggered **client-side**, not server-side
* `replace()` is unsafe for sanitization
* Blacklist-based filtering is fragile
* HTML encoding must be comprehensive
* Client-side sanitization errors are exploitable

---

## Dangerous Patterns to Avoid

Avoid sanitizing user input with:

* `string.replace("<", ...)`
* Partial or single-pass filtering
* Custom blacklist logic

Use proper encoding or trusted libraries instead.

---

## Final Summary

* Stored input processed by client-side JavaScript
* Flawed sanitization using `replace()`
* Extra characters bypass the filter
* HTML injection leads to JavaScript execution
* High-impact stored DOM-based XSS vulnerability

 
