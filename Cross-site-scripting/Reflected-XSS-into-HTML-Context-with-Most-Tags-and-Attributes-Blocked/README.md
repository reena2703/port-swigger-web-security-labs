# Cross-Site Scripting (XSS) – Reflected XSS with WAF Bypass
(Web Security Academy)

This lab demonstrates a **reflected XSS vulnerability protected by a Web Application Firewall (WAF)**.  
Most common XSS payloads are blocked, requiring **systematic enumeration** to identify allowed tags and attributes.

---

## Lab: Reflected XSS into HTML Context with Most Tags and Attributes Blocked

**Platform:** Web Security Academy  
**Category:** Cross-site scripting  
**Context:** HTML  
**Type:** Reflected XSS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

The application reflects user input into an **HTML context**, but a WAF blocks:

- Common HTML tags
- Common JavaScript event handlers
- Standard XSS payloads

To solve the lab, we must:

- Identify which **HTML tags** are allowed
- Identify which **event handlers** are allowed
- Construct a payload that executes **without user interaction**
- Trigger the `print()` function automatically in the victim’s browser

---

## Initial Test (Blocked Payload)

```html
<img src=1 onerror=print()>
````

 Blocked by the WAF.

---

## Step 1: Enumerating Allowed HTML Tags

### Intruder Setup

1. Submit a search request and send it to **Burp Intruder**

2. Replace the search parameter value with:

   ```html
   <>
   ```

3. Place payload markers between the brackets:

   ```html
   <§§>
   ```

4. From the XSS Cheat Sheet, copy the list of **HTML tags**

5. Paste them into **Payloads**

6. Start the attack

### Result

* Most tags returned **400 Bad Request**
* `<body>` returned **200 OK**

**`<body>` tag is allowed**

---

## Step 2: Enumerating Allowed Event Handlers

### Intruder Setup

1. Replace the search parameter with:

   ```html
   <body%20=1>
   ```

2. Place payload markers before `=`:

   ```html
   <body%20§§=1>
   ```

3. Clear previous payloads

4. Paste the list of **JavaScript event handlers**

5. Start the attack

### Result

* Most event handlers blocked
* `onresize` returned **200 OK**

 **`onresize` event is allowed**

---

## Final Payload Construction

The payload must:

* Escape the existing HTML context
* Inject a `<body>` tag
* Trigger `print()` automatically
* Avoid user interaction

### Final Encoded Payload

```html
"><body onresize=print()>
```

---

## Exploit Delivery (Victim Execution)

The `onresize` event fires when the iframe is resized automatically.

### Exploit Server Payload

```html
<iframe src="https://YOUR-LAB-ID.web-security-academy.net/?search=%22%3E%3Cbody%20onresize=print()%3E"
onload=this.style.width='100px'>
```

---

## Why This Works

* WAF blocks **most** tags and attributes, but not all
* `<body>` tag is permitted
* `onresize` event handler is permitted
* Changing iframe dimensions triggers `onresize`
* No user interaction required
* JavaScript executes automatically in victim’s browser

---

## Impact

* Reflected XSS despite WAF protection
* Arbitrary JavaScript execution
* Session compromise
* Credential theft
* WAF bypass through allowed primitives

---

## Key Lessons Learned

* WAFs are **not a guarantee of security**
* Enumeration beats assumptions
* Context-aware payloads are critical
* Non-interactive execution is often required
* Event handlers like `onresize` are commonly overlooked

---

## Final Summary

* Reflected XSS protected by a WAF
* Most vectors blocked
* Systematic enumeration identified allowed tag and attribute
* `<body onresize>` enabled JavaScript execution
* Fully automated exploit delivered to victim
 
