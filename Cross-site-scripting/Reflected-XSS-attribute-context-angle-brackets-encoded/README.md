# Web Security Academy – Reflected XSS (Attribute Context)

## Lab: Reflected XSS into Attribute with Angle Brackets HTML-Encoded

**Category:** Cross-site scripting  
**Context:** HTML attribute  
**Level:** Apprentice  
**Status:** Solved   

---

## What This Lab Is About

This lab demonstrates a **reflected XSS vulnerability** where:

- User input is reflected inside an **HTML attribute**
- Angle brackets (`<` and `>`) are HTML-encoded
- The application still allows attribute injection
- JavaScript can be executed using event handlers

This shows that encoding angle brackets alone is **not sufficient** to prevent XSS.

---

## Vulnerable Context

- User input is reflected inside a **quoted HTML attribute**
- Example vulnerable pattern:
 
<input value="USER_INPUT">

Even though < and > are encoded, the attribute itself can still be broken.

---

## Steps I Followed

Entered a random alphanumeric string into the search box

Intercepted the request using Burp Proxy

Sent the request to Burp Repeater

Observed that the input was reflected inside a quoted attribute

Replaced the input with a payload that breaks out of the attribute

---

## Payload Used
"onmouseover="alert(1)

---

## Why This Payload Works

The leading " closes the existing attribute value

A new attribute (onmouseover) is injected

JavaScript is executed when the user hovers over the element

No <script> tags are required

---

## Verification

Right-clicked the page

Selected Copy URL

Opened the URL in the browser

Hovered over the injected element

alert(1) was triggered successfully

---

## Impact

JavaScript execution in the victim’s browser

Session hijacking

Phishing attacks

DOM manipulation

---

## Key Lessons Learned

Encoding < and > alone does not prevent XSS

Attribute contexts require context-aware encoding

Event handlers are a common XSS vector

XSS payloads depend heavily on injection context

---

## Final Summary

Reflected XSS via attribute injection

Context: Quoted HTML attribute

Angle brackets encoded, but quotes were not

Exploitation achieved using an event handler
