# Cross-Site Scripting (XSS) – Custom HTML Tag Bypass
(Web Security Academy)

This lab demonstrates a **reflected XSS vulnerability** where **all standard HTML tags are blocked**, but **custom (non-standard) tags are still allowed**.

By abusing browser behavior with focusable elements, it is possible to execute JavaScript automatically.

---

## Lab: Reflected XSS into HTML Context with All Tags Blocked Except Custom Ones

**Platform:** Web Security Academy  
**Category:** Cross-site scripting  
**Context:** HTML  
**Type:** Reflected XSS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

The application applies strict filtering rules:

- All **standard HTML tags** (`<img>`, `<script>`, `<body>`, etc.) are blocked
- **Custom HTML tags** (non-standard tags) are allowed
- JavaScript execution is still possible via **event handlers**
- No user interaction is allowed for the solution

The goal is to:

- Inject a **custom HTML tag**
- Automatically trigger JavaScript execution
- Call `alert(document.cookie)` in the victim’s browser

---

## Key Observation

Modern browsers allow **custom tags** (for example `<xss>`), and these tags can still:

- Have attributes
- Contain JavaScript event handlers
- Receive focus when `tabindex` is set

Additionally:

- URL fragments (`#id`) automatically focus matching elements

---

## Exploitation Strategy

1. Inject a **custom HTML tag**
2. Assign it an `id`
3. Add an `onfocus` event handler
4. Make it focusable using `tabindex`
5. Use a URL fragment to focus the element automatically

---

## Final Payload (Encoded)

```html
<xss id=x onfocus=alert(document.cookie) tabindex=1>
````

Since angle brackets are URL-encoded, the payload is delivered in encoded form.

---

## Exploit Delivery

The exploit is delivered via the **Exploit Server** so that it runs automatically in the victim’s browser.

### Exploit Server Code

```html
<script>
location = 'https://YOUR-LAB-ID.web-security-academy.net/?search=%3Cxss+id%3Dx+onfocus%3Dalert%28document.cookie%29%20tabindex=1%3E#x';
</script>
```

---

## Why This Works

* Custom tags are **not blocked**
* `tabindex=1` makes the element focusable
* `onfocus` executes JavaScript when focused
* `#x` in the URL focuses the element automatically
* No user interaction is required
* JavaScript executes immediately in the victim’s browser

---

## Impact

* Reflected XSS despite strict HTML filtering
* Automatic JavaScript execution
* Cookie theft possible via `document.cookie`
* Demonstrates limitations of tag-based filtering

---

## Key Lessons Learned

* Blocking known tags is **not sufficient**
* Browsers support custom HTML elements
* Event handlers are powerful attack vectors
* URL fragments can be abused to trigger focus-based execution
* Context-aware filtering is essential

---

## Final Summary

* All standard HTML tags were blocked
* Custom tags remained allowed
* Focus-based event execution was abused
* Fully automated XSS achieved
* Victim execution succeeded without interaction

 
