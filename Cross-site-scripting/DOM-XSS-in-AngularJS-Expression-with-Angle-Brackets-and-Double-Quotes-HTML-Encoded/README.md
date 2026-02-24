# Cross-Site Scripting (XSS) – DOM-Based XSS (AngularJS)
(Web Security Academy)

DOM-based XSS can also occur through **JavaScript frameworks** like AngularJS when user input is evaluated as expressions.  
Even if angle brackets and quotes are HTML-encoded, insecure framework usage can still lead to JavaScript execution.

---

## Lab: DOM XSS in AngularJS Expression with Angle Brackets and Double Quotes HTML-Encoded

**Category:** Cross-site scripting  
**Type:** DOM-based XSS  
**Framework:** AngularJS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

This lab demonstrates a DOM-based XSS vulnerability where:

- User input is placed inside an AngularJS context
- The application uses the `ng-app` directive
- AngularJS evaluates expressions inside `{{ }}` (double curly braces)
- Angle brackets (`< >`) and double quotes are HTML-encoded
- JavaScript execution is still possible via AngularJS expression injection

---

## Vulnerable Flow

- **Source:** User-controlled search input
- **Sink:** AngularJS expression evaluation

AngularJS automatically evaluates expressions inside:

```html
{{ expression }}
````

When attacker input is injected into this context, arbitrary JavaScript can be executed.

---

## Payload Used

```js
{{$on.constructor('alert(1)')()}}
```

---

## Steps I Followed

1. Entered a random alphanumeric string into the search box
2. Viewed the page source
3. Observed that the input was placed inside an element using the `ng-app` directive
4. Confirmed AngularJS was active on the page
5. Replaced the input with the AngularJS payload
6. Clicked **Search**
7. AngularJS evaluated the injected expression
8. The `alert(1)` function executed successfully

---

## Why This Worked

* AngularJS evaluates expressions inside `{{ }}`
* Input was trusted and not sandboxed
* Encoding angle brackets does not stop AngularJS expression execution
* `$on.constructor` allows access to the JavaScript `Function` constructor
* JavaScript code execution is possible without `<script>` tags

---

## Impact

* Arbitrary JavaScript execution
* Session hijacking
* Credential theft
* DOM manipulation
* Client-side attacks through trusted frameworks

---

## Key Lessons Learned

* Frameworks can introduce XSS even when HTML is encoded
* AngularJS expression injection is extremely dangerous
* Encoding `< >` is not sufficient protection
* Client-side frameworks must not process untrusted input
* DOM XSS does not require script tags

---

## Common Dangerous Patterns in AngularJS

Avoid allowing user input in:

* `ng-app`
* `{{ }}` expressions
* `ng-bind`
* `ng-init`

---

## Final Summary

* Vulnerability exists entirely on the client side
* Source: Search input
* Sink: AngularJS expression evaluation
* Encoding was bypassed using framework logic
* Demonstrates high-impact DOM-based XSS via AngularJS

 
