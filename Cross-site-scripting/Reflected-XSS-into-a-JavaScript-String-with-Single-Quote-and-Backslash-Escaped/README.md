# Cross-Site Scripting (XSS) – JavaScript String Context
(Web Security Academy)

This lab demonstrates a **reflected XSS vulnerability** where user input is reflected inside a **JavaScript string**.  
Although **single quotes and backslashes are escaped**, it is still possible to escape the context by **breaking out of the `<script>` block entirely**.

---

## Lab: Reflected XSS into a JavaScript String with Single Quote and Backslash Escaped

**Category:** Cross-site scripting  
**Context:** JavaScript string  
**Type:** Reflected XSS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

This lab reflects user input into a JavaScript variable like:

```js
var searchTerm = 'USER_INPUT';
````

Security controls applied:

* Single quotes (`'`) are escaped
* Backslashes (`\`) are escaped
* Direct string-breaking payloads fail

Despite this, the application still allows **context switching**, which leads to XSS.

---

## Vulnerable Flow

* **Source:** User-controlled search input
* **Sink:** JavaScript string inside a `<script>` tag

The input is reflected directly into executable JavaScript.

---

## Initial Testing

### Test Payload

```text
test'payload
```

### Result

The application escapes the single quote:

```js
var searchTerm = 'test\'payload';
```

This prevents breaking out of the string using quotes alone.

---

## Exploitation Strategy

Instead of breaking out of the **string**, we break out of the **script block**.

### Key Insight

Escaping quotes does **not** protect against:

* HTML context termination
* Closing `<script>` tags
* Injecting a new script block

---

## Final Payload Used

```html
</script><script>alert(1)</script>
```

---

## Steps I Followed

1. Entered a random string in the search box

2. Intercepted the request using **Burp Suite**

3. Sent the request to **Burp Repeater**

4. Confirmed reflection inside a JavaScript string

5. Replaced the input with:

   ```html
   </script><script>alert(1)</script>
   ```

6. Sent the request

7. Copied the generated URL

8. Loaded the URL in the browser

9. The alert executed successfully

---

## Why This Worked

* The application escaped JavaScript characters, not HTML
* `</script>` terminates the existing script block
* The browser parses the injected `<script>` as a new executable block
* Context switching bypasses JavaScript escaping entirely

---

## Impact

* Arbitrary JavaScript execution
* Session hijacking
* Credential theft
* DOM manipulation
* Full client-side compromise

---

## Key Lessons Learned

* Escaping quotes is **not sufficient**
* Context matters more than encoding
* JavaScript escaping does not protect against HTML injection
* `<script>` block termination is a powerful bypass
* Output encoding must match the **exact output context**

---

## Secure Coding Takeaways

To prevent this vulnerability:

* Use context-aware encoding
* Avoid injecting untrusted data into scripts
* Use JSON encoding for JavaScript data
* Apply a strict Content Security Policy (CSP)

---

## Final Summary

* Input reflected inside a JavaScript string
* Quotes and backslashes escaped
* Script context still breakable
* Payload closes script tag and injects a new one
* Clean and reliable reflected XSS
 
