# Cross-Site Scripting (XSS) – DOM-Based XSS
(Web Security Academy)

DOM-based XSS vulnerabilities occur entirely on the **client side**.  
The server may return safe content, but insecure JavaScript logic in the browser allows attackers to execute malicious code.

---

## Lab: DOM XSS in jQuery Selector Sink Using a Hashchange Event

**Category:** Cross-site scripting  
**Type:** DOM-based XSS  
**Level:** Apprentice  
**Status:** Solved  

---

## What This Lab Is About

This lab demonstrates a DOM-based XSS vulnerability on the **home page**, where:

- The application reads user input from `location.hash`
- The value is passed directly into a jQuery `$()` selector
- A `hashchange` event triggers the vulnerable code
- Malicious HTML is interpreted and executed in the browser

---

## Vulnerable Flow

- **Source:** `location.hash`
- **Sink:** jQuery `$()` selector

The application uses jQuery to auto-scroll to a blog post whose title is taken from the URL fragment:

js
$(location.hash)

Because jQuery can interpret attacker-controlled input as HTML, this creates a DOM-based XSS vulnerability.

---

## Payload Used
### <img src=x onerror=print()>

---

## Exploit Delivered
### <iframe src="https://YOUR-LAB-ID.web-security-academy.net/#"
onload="this.src+='<img src=x onerror=print()>'"></iframe>

---

## Steps I Followed

Inspected the home page JavaScript using browser DevTools

Identified jQuery $() usage with location.hash

Opened the Exploit Server from the lab banner

Created a malicious iframe containing the XSS payload

Stored the exploit and clicked View exploit

Confirmed that print() executed in the browser

Clicked Deliver to victim

The lab was successfully solved

---

## Why This Worked

location.hash is fully user-controlled

jQuery $() treats crafted input as HTML

The hashchange event automatically triggers the vulnerable code

No input validation or sanitization was applied

---

## Impact

Arbitrary JavaScript execution in the victim’s browser

Client-side attacks without server-side interaction

DOM manipulation

Phishing and UI-based attacks

---

## Key Lessons Learned

DOM XSS can occur without form inputs or server reflection

jQuery selectors are dangerous with untrusted input

location.hash is a common and overlooked XSS source

Client-side code must be treated as untrusted

Exploit servers simulate real-world attack delivery

---

## Common Dangerous DOM Sinks

Avoid using untrusted input with:

jQuery $() selector

innerHTML

outerHTML

document.write()

insertAdjacentHTML()

## Final Summary

Vulnerability exists fully on the client side

Source: location.hash

Sink: jQuery selector

Payload delivered via exploit server

JavaScript executed using an HTML event handler

High-impact DOM-based XSS vulnerability


 
