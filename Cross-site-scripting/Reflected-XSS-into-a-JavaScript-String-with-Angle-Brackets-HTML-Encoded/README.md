# Cross-Site Scripting (XSS) – Reflected XSS in JavaScript String  
(Web Security Academy)

This lab demonstrates a **reflected XSS vulnerability** where user input is reflected inside a **JavaScript string**.  
Even though angle brackets are HTML-encoded, unsafe handling of user input inside JavaScript still leads to code execution.

---

## Lab: Reflected XSS into a JavaScript String with Angle Brackets HTML-Encoded

**Category:** Cross-site scripting  
**Type:** Reflected XSS  
**Context:** JavaScript string  
**Level:** Apprentice  
**Status:** Solved  

---

## What This Lab Is About

This lab shows that:

- User input is reflected inside a JavaScript string
- Angle brackets (`< >`) are HTML-encoded
- Encoding alone does not protect JavaScript contexts
- Breaking out of the string allows arbitrary JavaScript execution

---

## Vulnerable Flow

- **Source:** Search input (`location.search`)
- **Sink:** JavaScript string in inline script

Example vulnerable code pattern:

```js
var searchTerm = 'USER_INPUT';
````

If the input is not properly escaped for JavaScript, an attacker can break out of the string.

---

## Payload Used

```js
'-alert(1)-'
```

---

## Steps I Followed

1. Entered a random alphanumeric string into the search box
2. Intercepted the search request using **Burp Suite**
3. Sent the request to **Burp Repeater**
4. Observed that the input was reflected inside a JavaScript string
5. Replaced the input with the payload:

   ```
   '-alert(1)-'
   ```
6. Sent the modified request
7. Right-clicked the response and selected **Copy URL**
8. Pasted the URL into the browser
9. Loaded the page and observed that `alert(1)` executed

---

## Why This Worked

* The input was inserted directly into a JavaScript string
* Angle brackets were encoded, but **quotes were not safely handled**
* The payload closed the existing string
* JavaScript execution continued outside the string
* No proper JavaScript escaping was applied

---

## Impact

* Arbitrary JavaScript execution
* Session hijacking
* Credential theft
* Client-side data manipulation
* Reflected XSS attacks via crafted URLs

---

## Key Lessons Learned

* Encoding HTML characters is not enough
* JavaScript contexts require **JavaScript-specific escaping**
* Quotes (`'` and `"`) are dangerous in JS strings
* Context-aware output encoding is mandatory
* Reflected XSS can be delivered via a single URL

---

## Common Dangerous JavaScript Sinks

Avoid placing untrusted input into:

* Inline JavaScript strings
* `eval()`
* `setTimeout(string)`
* `setInterval(string)`
* `document.write()` inside scripts

---

## Final Summary

* Reflected XSS vulnerability
* Context: JavaScript string
* Angle brackets encoded but still exploitable
* Payload breaks out of the string and executes JavaScript
* Demonstrates why output encoding must match the context
 
