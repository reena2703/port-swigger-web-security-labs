# Cross-Site Scripting (XSS) – DOM-Based XSS
(Web Security Academy)

DOM-based XSS occurs entirely on the **client side**.  
The vulnerability exists in JavaScript code running in the browser, not in server-side responses.

---

## Lab Completed

---

## 3. DOM XSS in document.write Sink Using location.search

**Lab level:** Apprentice  
**Vulnerability type:** DOM-based XSS  
**Source:** `location.search`  
**Sink:** `document.write()`  

---

### What This Lab Is About

- The application tracks search queries using JavaScript
- User-controlled input is taken from `location.search`
- The input is written directly to the page using `document.write`
- No sanitization or encoding is applied
- This allows JavaScript execution in the browser

---

### What I Observed

1. Entered a random string in the search box
2. Inspected the page using browser developer tools
3. Found that the input was injected into the HTML like this:

```html
<img src="search-term">
````

The input was being written directly inside an **HTML attribute context**.

---

### Exploit Used

To break out of the `img` attribute and inject JavaScript:

```html
"><svg onload=alert(1)>
```

---

### Steps I Followed

1. Entered the payload into the search box:

   ```
   "><svg onload=alert(1)>
   ```
2. Submitted the search
3. The payload was inserted into the page by `document.write`
4. The injected `<svg>` tag executed automatically
5. `alert(1)` was triggered

---

### Why This Worked

* `location.search` is fully attacker-controlled
* `document.write()` inserts raw HTML into the DOM
* No output encoding or input validation is applied
* The payload breaks out of the attribute context and injects a new HTML element

---

### Impact

* Arbitrary JavaScript execution in the victim’s browser
* Session hijacking
* Credential theft
* DOM manipulation
* Phishing or malware delivery

---

### Key Lessons Learned

* DOM XSS does not require server-side reflection
* `document.write()` is extremely dangerous
* Client-side input must be treated as untrusted
* Context-aware encoding is required even in JavaScript
* Attribute contexts are easy to break out of

---

### Common Dangerous DOM Sinks

Be careful with:

* `document.write()`
* `innerHTML`
* `outerHTML`
* `insertAdjacentHTML()`
* `eval()`

---

### Final Summary

* DOM XSS happens entirely in the browser
* Source: `location.search`
* Sink: `document.write`
* No server interaction is required
* High-impact client-side vulnerability
 
