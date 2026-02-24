# Cross-Site Scripting (XSS) – Canonical Link Tag Injection
(Web Security Academy)

This lab demonstrates a **reflected XSS vulnerability** where user input is reflected inside a **canonical `<link>` tag**.  
Although **angle brackets are escaped**, it is still possible to inject **HTML attributes** and execute JavaScript using browser-specific behavior.

---

## Lab: Reflected XSS in Canonical Link Tag

**Platform:** Web Security Academy  
**Category:** Cross-site scripting  
**Context:** HTML (canonical link tag)  
**Type:** Reflected XSS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

The application reflects user-controlled input into a `<link rel="canonical">` tag:

- Angle brackets (`<` `>`) are HTML-encoded
- Input is injected **inside an existing HTML tag**
- Direct script injection is blocked
- Attribute injection is still possible

The challenge is to:

- Inject a malicious **HTML attribute**
- Execute JavaScript **without using `<script>`**
- Trigger execution via **keyboard interaction**
- Exploit behavior that works **only in Chrome**

---

## Vulnerable Context

User input is reflected into a canonical link tag like:

```html
<link rel="canonical" href="https://example.com/?USER_INPUT">
````

Because the input is placed **inside a quoted attribute**, it is possible to:

* Break out of the attribute value
* Inject new attributes
* Attach JavaScript event handlers

---

## Exploit Technique Used

### Attribute Injection + `accesskey`

The payload injects:

* `accesskey` → assigns a keyboard shortcut
* `onclick` → executes JavaScript when triggered

This avoids the need for angle brackets or script tags.

---

## Final Working Payload

Visit the following URL (replace `YOUR-LAB-ID`):

```text
https://YOUR-LAB-ID.web-security-academy.net/?'accesskey='x'onclick='alert(1)
```

---

## How the Exploit Triggers

The injected attributes result in behavior equivalent to:

```html
onclick="alert(1)"
accesskey="x"
```

When the victim presses the access key, the JavaScript executes.

### Simulated Victim Key Combinations

* **Windows:** `ALT + SHIFT + X`
* **macOS:** `CTRL + ALT + X`
* **Linux:** `Alt + X`

 This exploit works **only in Google Chrome**, as required by the lab.

---

## Why This Worked

* Angle brackets were escaped, but attributes were not filtered
* Attribute injection is possible inside quoted values
* `accesskey` enables keyboard-triggered interaction
* `onclick` executes JavaScript without `<script>`
* Chrome supports this access key behavior

---

## Impact

* JavaScript execution via reflected input
* User interaction–based XSS
* Can be combined with social engineering
* Demonstrates that escaping `< >` alone is insufficient

---

## Key Lessons Learned

* Escaping angle brackets does not fully prevent XSS
* Attribute injection is a powerful attack vector
* Non-obvious HTML attributes can enable execution
* Browser-specific behaviors matter in exploitation
* Context-aware output encoding is critical

---

## Final Summary

* Input reflected into a canonical `<link>` tag
* Angle brackets blocked, attributes allowed
* `accesskey` + `onclick` used for execution
* JavaScript triggered via keyboard shortcut
* Lab successfully solved using Chrome-specific behavior
 
