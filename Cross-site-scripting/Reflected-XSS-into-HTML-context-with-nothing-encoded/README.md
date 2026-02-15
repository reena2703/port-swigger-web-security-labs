# Cross-Site Scripting (XSS) – Client-Side Topics
(Web Security Academy)

Client-side vulnerabilities add an extra layer of complexity because:
- They execute in the **user’s browser**
- They often depend on **user interaction**
- Exploitation usually happens via **HTML, JavaScript, or the DOM**

XSS allows an attacker to **execute malicious JavaScript** in another user’s browser.

---

## What is Cross-Site Scripting (XSS)?

Cross-Site Scripting occurs when:
- User-controlled input is included in a web page
- The input is **not properly sanitized or encoded**
- The browser executes it as **JavaScript**

### Impact of XSS
- Steal session cookies
- Perform actions as another user
- Deface websites
- Phishing and credential theft
- Full account takeover (in some cases)

---

## Types of XSS

- **Reflected XSS** – payload comes from the request and is reflected in the response
- **Stored XSS** – payload is stored on the server and served to users
- **DOM-based XSS** – vulnerability exists in client-side JavaScript only

---

## Lab Completed

---

## 1. Reflected XSS into HTML Context with Nothing Encoded

**Lab level:** Apprentice  
**Vulnerability type:** Reflected XSS  
**Context:** HTML context  
**Encoding:** None

---

### What I Observed

- User input from the **search box** is reflected directly into the HTML response
- No encoding or sanitization is applied
- The browser interprets injected HTML and JavaScript as valid code

---

### Exploit Used

```html
<script>alert(1)</script>
````

---

### Why This Worked

* The application inserts user input **directly into the HTML**
* `<script>` tags are not filtered or encoded
* The browser executes the injected JavaScript

---

### Key Lesson Learned

* Any untrusted input rendered into HTML without encoding is dangerous
* Reflected XSS can be exploited instantly with a single request
* Always test input fields like:

  * Search
  * Filters
  * Error messages
  * URL parameters

---

## XSS Testing Checklist (Beginner Level)

When testing for reflected XSS, try:

* `<script>alert(1)</script>`
* `"><script>alert(1)</script>`
* `<img src=x onerror=alert(1)>`
* `<svg onload=alert(1)>`

Check:

* Is input reflected?
* Is it inside HTML, attribute, or JavaScript context?
* Is any encoding applied?

---

## Final Summary

* Reflected XSS happens **immediately** via user input
* No storage is required on the server
* Proper **output encoding** is the primary defense
* Client-side vulnerabilities are just as dangerous as server-side ones

 
