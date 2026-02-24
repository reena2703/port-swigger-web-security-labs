# Cross-Site Scripting (XSS) – Stored XSS in JavaScript Event Handler
(Web Security Academy)

This lab demonstrates a **stored cross-site scripting vulnerability** where user input is embedded inside an **onclick JavaScript event handler**.  
Even though **angle brackets, double quotes, single quotes, and backslashes are escaped**, it is still possible to execute JavaScript by carefully crafting the payload.

---

## Lab: Stored XSS into onclick Event with Multiple Encodings Applied

**Category:** Cross-site scripting  
**Context:** JavaScript event handler (`onclick`)  
**Type:** Stored XSS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

This lab stores user-supplied input from the **Website** field of a comment and later embeds it into an `onclick` attribute on the comment author’s name.

Security controls applied:

- Angle brackets (`< >`) HTML-encoded  
- Double quotes (`"`) HTML-encoded  
- Single quotes (`'`) escaped  
- Backslashes (`\`) escaped  

Despite these protections, the application still allows **JavaScript execution**.

---

## Vulnerable Flow

- **Source:** Comment "Website" input field
- **Sink:** `onclick` JavaScript event handler

The application generates code similar to:

```html
<a onclick="location.href='USER_INPUT'">Author</a>
````

---

## Initial Testing

1. Posted a comment with a random alphanumeric string in the **Website** field
2. Viewed the comment and intercepted the request with **Burp Suite**
3. Observed that the value was reflected inside an `onclick` attribute

This confirmed the injection point was inside **JavaScript code**, not HTML markup.

---

## Exploitation Strategy

Because:

* Quotes are escaped
* Script tags are blocked
* HTML injection is not possible

We instead inject a **JavaScript expression** that executes inside the existing event handler logic.

---

## Final Payload Used

```text
http://foo?&apos;-alert(1)-&apos;
```

---

## Steps I Followed

1. Posted a comment with a random value in the **Website** field

2. Intercepted the request using **Burp Suite**

3. Sent the request to **Burp Repeater**

4. Confirmed the value was reflected inside an `onclick` handler

5. Replaced the Website value with:

   ```
   http://foo?&apos;-alert(1)-&apos;
   ```

6. Submitted the modified request

7. Copied the generated URL of the blog post

8. Loaded it in the browser

9. Clicked the comment author’s name

10. `alert(1)` executed successfully

---

## Why This Worked

* HTML encoding does not prevent JavaScript execution inside event handlers
* The injected payload breaks the intended JavaScript logic
* The `-alert(1)-` expression executes as valid JavaScript
* Context-aware escaping was incomplete

---

## Impact

* Stored JavaScript execution
* Affects every user who views the comment
* Session hijacking
* Credential theft
* Persistent client-side compromise

---

## Key Lessons Learned

* Encoding characters alone is not enough
* JavaScript contexts require JavaScript-safe encoding
* Event handlers are dangerous sinks
* Stored XSS is more severe than reflected XSS
* Output encoding must match the **exact execution context**

---

## Secure Coding Takeaways

To prevent this vulnerability:

* Never embed untrusted data inside event handlers
* Avoid inline JavaScript (`onclick`, `onload`, etc.)
* Use strict context-aware output encoding
* Enforce a strong Content Security Policy (CSP)

---

## Final Summary

* Stored XSS vulnerability
* Injection point inside an `onclick` JavaScript event
* Multiple encodings applied but still bypassable
* JavaScript expression injection leads to execution
* High-impact persistent XSS
 
