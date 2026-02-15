# Cross-Site Scripting (XSS) – Stored XSS
(Web Security Academy)

Stored XSS is more dangerous than reflected XSS because:
- The payload is **saved on the server**
- It executes **automatically for every user** who views the affected page
- No interaction is required after the payload is stored

---

## Lab Completed

---

## 2. Stored XSS into HTML Context with Nothing Encoded

**Lab level:** Apprentice  
**Vulnerability type:** Stored XSS  
**Context:** HTML context  
**Encoding:** None

---

### What I Observed

- The application allows users to post comments on blog posts
- User-supplied comment content is **stored on the server**
- Stored input is later rendered into the HTML page **without encoding**
- JavaScript inside comments executes when the blog post is viewed

---

### Exploit Used

```html
<script>alert(1)</script>
````

---

### Steps I Followed

1. Entered the XSS payload into the **comment box**
2. Filled in name, email, and website fields
3. Clicked **Post comment**
4. Reloaded the blog post
5. JavaScript executed automatically

---

### Why This Worked

* The application does not sanitize or encode stored user input
* `<script>` tags are allowed and executed by the browser
* The payload is stored and served to all users who view the page

---

### Impact

* JavaScript executes in every visitor’s browser
* Can steal cookies or session tokens
* Can perform actions as other users
* Affects multiple users, not just the attacker

---

### Key Lessons Learned

* Stored XSS is more severe than reflected XSS
* Any stored user input must be treated as untrusted
* Comment systems, reviews, and profile fields are common targets
* Output encoding is mandatory before rendering stored data

---

## Stored XSS Testing Checklist

When testing stored inputs, check:

* Comments
* Reviews
* User profiles
* Messages
* Support tickets

Try payloads like:

* `<script>alert(1)</script>`
* `<img src=x onerror=alert(1)>`
* `<svg onload=alert(1)>`

---

## Final Summary

* Stored XSS persists on the server
* Executes automatically for all viewers
* High impact vulnerability
* Proper input handling and output encoding are critical defenses

 
