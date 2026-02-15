# Cross-Site Scripting (XSS) – DOM-Based XSS
(Web Security Academy)

DOM-based XSS happens entirely on the **client side**.  
The server response itself is safe, but insecure JavaScript logic in the browser makes the application vulnerable.

---

## Lab: DOM XSS in innerHTML Sink Using location.search

**Category:** Cross-site scripting  
**Type:** DOM-based XSS  
**Level:** Apprentice  
**Status:** Solved 

---

## What This Lab Is About

This lab demonstrates a DOM-based XSS vulnerability where:

- User input is taken from `location.search`
- The input is written directly into the page using `innerHTML`
- No sanitization or encoding is applied
- JavaScript executes in the browser as a result

---

## Vulnerable Flow

- **Source:** `location.search`
- **Sink:** `innerHTML`

The application dynamically updates a `<div>` using:

```js
element.innerHTML = userInput;
````

Because `innerHTML` parses and renders HTML, attacker-controlled input can inject malicious elements.

---

## Payload Used

```html
<img src=1 onerror=alert(1)>
```

---

## Steps I Followed

1. Entered the payload into the search box:

   ```
   <img src=1 onerror=alert(1)>
   ```
2. Clicked **Search**
3. The application inserted the input into the page using `innerHTML`
4. The browser attempted to load the image
5. The invalid `src` caused an error
6. The `onerror` event handler executed
7. `alert(1)` was triggered

---

## Why This Worked

* `location.search` is fully user-controlled
* `innerHTML` interprets input as real HTML
* Event handlers like `onerror` allow JavaScript execution
* No client-side filtering or encoding was applied

---

## Impact

* Arbitrary JavaScript execution in the victim’s browser
* Session hijacking
* Credential theft
* DOM manipulation
* Client-side phishing attacks

---

## Key Lessons Learned

* DOM XSS does not require server-side reflection
* `innerHTML` is dangerous when used with untrusted input
* Blocking `<script>` tags alone is not sufficient
* HTML event handlers can execute JavaScript
* Client-side code must follow the same security rules as server-side code

---

## Common Dangerous DOM Sinks

Avoid using untrusted input with:

* `innerHTML`
* `outerHTML`
* `document.write()`
* `insertAdjacentHTML()`

---

## Final Summary

* Vulnerability exists fully on the client side
* Source: `location.search`
* Sink: `innerHTML`
* Payload uses an image error event to execute JavaScript
* Simple but high-impact DOM-based XSS

 
