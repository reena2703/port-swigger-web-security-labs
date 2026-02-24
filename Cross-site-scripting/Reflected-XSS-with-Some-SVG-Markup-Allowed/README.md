# Cross-Site Scripting (XSS) – SVG-Based Filter Bypass
(Web Security Academy)

This lab demonstrates a **reflected XSS vulnerability** where most common HTML tags are blocked, but **some SVG markup and events are still allowed**, making it possible to bypass the filter.

---

## Lab: Reflected XSS with Some SVG Markup Allowed

**Platform:** Web Security Academy  
**Category:** Cross-site scripting  
**Context:** HTML  
**Type:** Reflected XSS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

The application attempts to protect against XSS by:

- Blocking common HTML tags such as `<script>` and `<img>`
- Returning a **400 error** for most injected tags
- Allowing certain **SVG-related tags and attributes**

The goal is to:

- Identify which SVG tags are allowed
- Find an executable SVG event handler
- Trigger `alert()` without user interaction

---

## Initial Test (Blocked Payload)

```html
<img src=1 onerror=alert(1)>
````

 This payload is blocked by the filter.

---

## Enumeration Using Burp Intruder

To identify which tags and events were allowed, Burp Intruder was used.

### Step 1: Tag Enumeration

* Replace search input with:

  ```
  <>
  ```
* Add payload position:

  ```
  <§§>
  ```
* Use **XSS Cheat Sheet – HTML Tags**
* Result:

  * Most tags → **400 response**
  * Allowed tags:

    * `<svg>`
    * `<animatetransform>`
    * `<title>`
    * `<image>`

---

### Step 2: Event Enumeration

* Payload template:

  ```
  <svg><animatetransform §§=1>
  ```
* Use **XSS Cheat Sheet – Events**
* Result:

  * Most events → **400 response**
  * Allowed event:

    * `onbegin`

---

## Final Working Payload (Encoded)

```html
"><svg><animatetransform onbegin=alert(1)>
```

### URL-Encoded Version

```
https://YOUR-LAB-ID.web-security-academy.net/?search=%22%3E%3Csvg%3E%3Canimatetransform+onbegin%3Dalert%281%29%3E
```

---

## Why This Works

* SVG tags are **not fully blocked**
* `<animatetransform>` supports animation events
* `onbegin` fires automatically when the animation starts
* No user interaction is required
* JavaScript executes immediately on page load

---

## Impact

* Reflected XSS despite aggressive filtering
* Automatic JavaScript execution
* Cookie theft and session hijacking possible
* Demonstrates weakness of blacklist-based WAF rules

---

## Key Lessons Learned

* Blocking common tags is not enough
* SVG elements are powerful XSS vectors
* Animation events like `onbegin` can auto-execute
* Blacklist-based filters are easy to bypass
* Proper output encoding is the only reliable defense

---

## Final Summary

* Common XSS payloads were blocked
* SVG tags remained accessible
* Event-based execution bypassed the filter
* Fully automated reflected XSS achieved
* Lab successfully solved
 
