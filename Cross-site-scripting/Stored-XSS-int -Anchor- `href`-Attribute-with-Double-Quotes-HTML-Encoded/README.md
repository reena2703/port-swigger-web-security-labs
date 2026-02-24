# Cross-Site Scripting (XSS) – Stored XSS in Anchor `href` Attribute  
(Web Security Academy)

Stored XSS occurs when **malicious input is saved on the server** and later executed in another user’s browser.  
This lab focuses on **attribute-context XSS** within an anchor (`<a>`) tag, even when double quotes are HTML-encoded.

---

## Lab: Stored XSS into Anchor `href` Attribute with Double Quotes HTML-Encoded

**Category:** Cross-site scripting  
**Type:** Stored XSS  
**Context:** Anchor `href` attribute  
**Level:** Apprentice  
**Status:** Solved  

---

## What This Lab Is About

This lab demonstrates a stored XSS vulnerability where:

- User input is stored via the **comment functionality**
- The input is reflected inside an anchor (`<a>`) tag’s `href` attribute
- Double quotes (`"`) are HTML-encoded
- JavaScript URLs are still allowed and executed when clicked

---

## Vulnerable Flow

- **Source:** Website field in comment form
- **Sink:** `<a href="USER_INPUT">`

The application generates links like:

```html
<a href="USER_INPUT">Author Name</a>
````

Because the browser allows `javascript:` URLs inside `href`, JavaScript can execute when the link is clicked.

---

## Payload Used

```html
javascript:alert(1)
```

---

## Steps I Followed

1. Posted a comment with a random alphanumeric string in the **Website** field
2. Intercepted the request using **Burp Suite** and sent it to **Burp Repeater**
3. Loaded the blog post to view the comment
4. Intercepted the page load request and sent it to **Burp Repeater**
5. Observed that the input was reflected inside an anchor `href` attribute
6. Repeated the process and replaced the Website input with:

   ```
   javascript:alert(1)
   ```
7. Reloaded the blog post
8. Clicked on the comment author’s name
9. `alert(1)` executed successfully

---

## Why This Worked

* The application did not restrict URL schemes
* `javascript:` URLs are valid in anchor `href` attributes
* HTML-encoding quotes does **not** prevent JavaScript URLs
* No validation or allowlist was applied to the `href` value

---

## Impact

* Persistent JavaScript execution
* Affects all users who view the comment
* Session hijacking
* Credential theft
* Phishing via malicious links

---

## Key Lessons Learned

* Encoding characters alone does not stop XSS
* URL schemes must be strictly validated
* `javascript:` URLs are dangerous in anchor tags
* Stored XSS is more severe than reflected XSS
* Context-aware output handling is critical

---

## Dangerous URL Schemes to Block

Applications should restrict:

* `javascript:`
* `data:`
* `vbscript:`

Use strict allowlists such as:

* `https://`
* `http://`

---

## Final Summary

* Stored XSS vulnerability
* Context: anchor `href` attribute
* Double quotes encoded, but JavaScript URLs allowed
* Payload executed when victim clicks the link
* High-impact vulnerability with simple exploitation
 
 
