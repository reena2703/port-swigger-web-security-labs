# Web Security Academy – DOM-Based XSS
## Lab: DOM XSS in jQuery Selector Sink Using a hashchange Event

**Category:** Cross-site scripting  
**Type:** DOM-based XSS  
**Level:** Apprentice  
**Status:** Solved   

---

## What This Lab Is About

This lab demonstrates a **DOM-based XSS vulnerability** caused by unsafe use of
jQuery’s `$()` selector with attacker-controlled data from `location.hash`.

The page automatically scrolls to a post whose title is taken from the URL hash.
Because the hash value is not sanitized, it can be abused to inject HTML and
execute JavaScript in the victim’s browser.

---

## Vulnerable Flow

- **Source:** `location.hash`
- **Sink:** jQuery `$()` selector

The vulnerable JavaScript logic:
- Reads data from the URL fragment (`#`)
- Passes it directly into a jQuery selector
- Injects attacker-controlled HTML into the DOM

---

## Goal of the Lab

- Deliver a client-side exploit
- Execute JavaScript in the victim’s browser
- Trigger the `print()` function

---

## Exploit Used

The exploit was delivered using the **exploit server** with a malicious iframe:

```html
<iframe src="https://YOUR-LAB-ID.web-security-academy.net/#"
onload="this.src+='<img src=x onerror=print()>'"></iframe>


Steps I Followed

Inspected the home page JavaScript using browser DevTools

Identified that location.hash was being used inside a jQuery selector

Opened the exploit server from the lab banner

Added the malicious iframe payload in the Body section

Stored the exploit

Clicked View exploit to verify execution

Confirmed that print() was triggered in the browser

Clicked Deliver to victim to complete the lab

Why This Worked

location.hash is fully attacker-controlled

jQuery $() treats input as HTML when selectors are unsafe

The injected <img> tag executes JavaScript via the onerror event

No sanitization or validation was applied to the hash value

Impact

Arbitrary JavaScript execution in the victim’s browser

Cookie theft

Session hijacking

Client-side phishing attacks

No server-side interaction required

Key Lessons Learned

DOM XSS can be triggered via URL fragments (#)

jQuery selectors are dangerous when built from untrusted input

location.hash is commonly overlooked but fully attacker-controlled

Client-side vulnerabilities can still require victim interaction

Exploit servers are often used to deliver DOM-based attacks

Final Summary

DOM-based XSS via jQuery selector

Source: location.hash

Sink: jQuery $() function

Payload delivered using an iframe

JavaScript executed using an image error handler
