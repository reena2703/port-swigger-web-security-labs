# Cross-Site Scripting (XSS) – DOM-Based XSS  
(Web Security Academy)

DOM-based XSS occurs entirely on the **client side**.  
The server response itself is safe, but insecure JavaScript logic in the browser makes the application vulnerable.

---

## Lab: DOM XSS in jQuery selector sink using a hashchange event

**Category:** Cross-site scripting  
**Type:** DOM-based XSS  
**Level:** Apprentice  
**Status:** Solved  

---

## What This Lab Is About

This lab demonstrates a DOM-based XSS vulnerability on the home page where:

- jQuery’s `$()` selector is used
- User-controlled input comes from `location.hash`
- The input is treated as HTML by jQuery
- JavaScript executes in the victim’s browser

---

## Vulnerable Flow

- **Source:** `location.hash`
- **Sink:** `jQuery $()` selector

The application uses logic similar to:

```js
$(location.hash)
````

Because jQuery interprets attacker-controlled input as HTML, this results in a DOM-based XSS vulnerability.

---

## Payload Used

```html
<img src=x onerror=print()>
```

---

## Exploit Delivered

```html
<iframe src="https://YOUR-LAB-ID.web-security-academy.net/#"
onload="this.src+='<img src=x onerror=print()>'"></iframe>
```

---

## Steps I Followed

1. Inspected the home page JavaScript using browser DevTools
2. Identified jQuery `$()` usage with `location.hash`
3. Opened the **Exploit Server** from the lab banner
4. Created a malicious `<iframe>` containing the payload
5. Stored the exploit and clicked **View exploit**
6. Confirmed that `print()` executed in the browser
7. Delivered the exploit to the victim
8. Lab was solved successfully

---

## Why This Worked

* `location.hash` is fully attacker-controlled
* jQuery `$()` can parse HTML, not just selectors
* Event handlers like `onerror` allow JavaScript execution
* No client-side validation or sanitization was applied

---

## Impact

* Arbitrary JavaScript execution
* Session hijacking
* Credential theft
* DOM manipulation
* Client-side phishing attacks

---

## Key Lessons Learned

* DOM-based XSS does not require server-side reflection
* jQuery selectors can become dangerous when used with untrusted input
* URL fragments (`#`) are often overlooked attack vectors
* Blocking `<script>` tags alone is not enough
* Client-side code must be treated as untrusted

---

## Common Dangerous DOM Sinks

Avoid using untrusted input with:

* `innerHTML`
* `outerHTML`
* `document.write()`
* `insertAdjacentHTML()`
* `jQuery $()`

---

## Final Summary

* Vulnerability exists entirely on the client side
* Source: `location.hash`
* Sink: jQuery selector `$()`
* Exploit delivered via iframe
* JavaScript executed using an image error event
* Simple but high-impact DOM-based XSS

 

Just say the word 👌
```
