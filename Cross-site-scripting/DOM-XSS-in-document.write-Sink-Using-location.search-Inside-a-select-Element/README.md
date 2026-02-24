# Cross-Site Scripting (XSS) – DOM-Based XSS
(Web Security Academy)

DOM-based XSS occurs entirely in the browser due to insecure JavaScript logic.  
The server response itself is safe, but dangerous DOM manipulation leads to client-side code execution.

---

## Lab: DOM XSS in document.write Sink Using location.search Inside a select Element

**Category:** Cross-site scripting  
**Type:** DOM-based XSS  
**Context:** HTML (`<select>` element)  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

This lab demonstrates a DOM-based XSS vulnerability where:

- User input is taken from `location.search`
- The input is written to the page using `document.write()`
- The data is placed inside a `<select>` element
- No sanitization or validation is applied
- An attacker can break out of the HTML context and execute JavaScript

---

## Vulnerable Flow

- **Source:** `location.search` (`storeId` parameter)
- **Sink:** `document.write()`

The application dynamically creates a `<select>` option using JavaScript:

```js
document.write('<option>' + storeId + '</option>');
````

Because `document.write()` directly injects HTML into the DOM, attacker-controlled input can break out of the intended structure.

---

## Payload Used

```html
"></select><img src=1 onerror=alert(1)>
```

URL-encoded in the request:

```
product?productId=1&storeId="></select><img%20src=1%20onerror=alert(1)>
```

---

## Steps I Followed

1. Navigated to a product page
2. Observed that the stock checker uses a `storeId` parameter from the URL
3. Added a random value to the `storeId` parameter
4. Reloaded the page and saw the value appear as an option in the dropdown
5. Inspected the dropdown and confirmed the value was inside a `<select>` element
6. Replaced the value with the malicious payload
7. Reloaded the page with the crafted URL
8. The `<select>` element was closed
9. An `<img>` tag was injected
10. The invalid image triggered `onerror`
11. `alert(1)` executed successfully

---

## Why This Worked

* `location.search` is fully attacker-controlled
* `document.write()` directly injects HTML into the DOM
* The payload breaks out of the `<select>` element
* Event handlers like `onerror` allow JavaScript execution
* No client-side validation or encoding was applied

---

## Impact

* Arbitrary JavaScript execution
* Session hijacking
* Credential theft
* DOM manipulation
* Client-side phishing attacks

---

## Key Lessons Learned

* DOM XSS can occur without server-side reflection
* `document.write()` is extremely dangerous with untrusted input
* Context matters: breaking out of HTML elements enables execution
* Encoding input alone is not enough
* Client-side code must be treated as untrusted

---

## Common Dangerous DOM Sinks

Avoid using untrusted input with:

* `document.write()`
* `innerHTML`
* `outerHTML`
* `insertAdjacentHTML()`

---

## Final Summary

* Vulnerability exists entirely on the client side
* Source: `location.search`
* Sink: `document.write()`
* Context: `<select>` element
* Payload breaks out of HTML and executes JavaScript
* Demonstrates high-risk DOM-based XSS behavior

 
