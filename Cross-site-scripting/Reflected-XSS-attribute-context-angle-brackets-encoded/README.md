# Cross-Site Scripting (XSS) – Reflected XSS in Attribute Context  
(Web Security Academy)

Reflected XSS occurs when **user input is immediately reflected** in the server’s HTTP response without proper sanitization or encoding.

This lab focuses on **attribute-context XSS**, where angle brackets are HTML-encoded, but it’s still possible to inject JavaScript by breaking out of an HTML attribute.

---

## Lab: Reflected XSS into Attribute with Angle Brackets HTML-Encoded

**Category:** Cross-site scripting  
**Type:** Reflected XSS  
**Context:** HTML attribute  
**Level:** Apprentice  
**Status:** Solved  

---

## What This Lab Is About

This lab demonstrates a reflected XSS vulnerability where:

- User input is reflected into an **HTML attribute**
- Angle brackets (`< >`) are HTML-encoded
- Quotes are **not properly handled**
- An attacker can inject a new attribute with a JavaScript event handler

---

## Vulnerable Flow

- **Source:** Search input
- **Sink:** HTML attribute value

The application reflects user input like this:

```html
<input value="USER_INPUT">
````

Because the input is placed inside a **quoted attribute**, escaping the quote allows injection of a new attribute.

---

## Payload Used

```html
"onmouseover="alert(1)
```

---

## Steps I Followed

1. Entered a random alphanumeric string in the search box
2. Intercepted the request using **Burp Suite**
3. Sent the request to **Burp Repeater**
4. Observed that the input was reflected inside a **quoted HTML attribute**
5. Replaced the input with the payload:

   ```
   "onmouseover="alert(1)
   ```
6. Sent the request and copied the generated URL
7. Opened the URL in the browser
8. Moved the mouse over the injected element
9. `alert(1)` executed successfully

---

## Why This Worked

* Angle brackets were encoded, but **quotes were not**
* Escaping the quote allowed injection of a new attribute
* Event handlers like `onmouseover` execute JavaScript
* No proper context-aware encoding was applied

---

## Impact

* Arbitrary JavaScript execution
* Session hijacking
* Credential theft
* DOM manipulation
* Phishing attacks

---

## Key Lessons Learned

* Encoding `<` and `>` alone is **not sufficient**
* Attribute contexts require **attribute-aware encoding**
* Event handlers are powerful XSS vectors
* Reflected XSS can still be exploited without `<script>` tags
* Always consider **where** user input is placed in HTML

---

## Common Dangerous Attribute Contexts

Be careful when reflecting untrusted input into:

* `value=""`
* `href=""`
* `src=""`
* `data-*` attributes
* Inline event handlers

---

## Final Summary

* Reflected XSS vulnerability
* Context: HTML attribute
* Angle brackets encoded, quotes not handled
* Payload escapes attribute and injects event handler
* JavaScript executed via `onmouseover`
* Simple bypass with high real-world impact
 

 
