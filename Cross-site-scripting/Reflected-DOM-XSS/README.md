# Cross-Site Scripting (XSS) – Reflected DOM XSS
(Web Security Academy)

Reflected DOM XSS is a hybrid vulnerability where **server-side reflection** combines with **unsafe client-side JavaScript**.  
The server reflects user input safely, but JavaScript logic in the browser processes it insecurely and writes it into a dangerous sink.

---

## Lab: Reflected DOM XSS

**Category:** Cross-site scripting  
**Type:** Reflected DOM-based XSS  
**Level:** Practitioner  
**Status:** Solved  

---

## What This Lab Is About

This lab demonstrates a reflected DOM XSS vulnerability where:

- User input is sent to the server
- The server reflects the input inside a JSON response
- A client-side JavaScript file processes the reflected data
- The data is passed into an `eval()` function
- Improper escaping allows JavaScript injection

---

## Vulnerable Flow

- **Source:** Search input (HTTP request)
- **Reflection:** JSON response (`search-results`)
- **Sink:** `eval()` function in client-side JavaScript

The application uses code similar to:

```js
eval("var data = " + searchResults);
````

Because `eval()` executes JavaScript, malformed input can break out of the intended context.

---

## Payload Used

```text
\"-alert(1)}//
```

---

## Steps I Followed

1. Enabled **Intercept** in Burp Suite
2. Searched for a random string (e.g. `XSS`) using the search bar
3. Forwarded the request in Burp Proxy
4. Observed the search term reflected inside a JSON response (`search-results`)
5. Opened `searchResults.js` from the site map
6. Noticed the JSON response was passed directly into `eval()`
7. Tested how characters were escaped
8. Discovered that **quotation marks were escaped**, but **backslashes were not**
9. Injected the payload into the search field
10. The JavaScript string was broken
11. `alert(1)` executed successfully

---

## Why This Worked

* User input was reflected by the server
* Backslashes (`\`) were not escaped properly
* The server added an extra backslash during escaping
* The resulting double-backslash canceled the escaping
* The string context was broken
* `eval()` executed attacker-controlled JavaScript

Resulting JSON:

```json
{"searchTerm":"\\"-alert(1)}//", "results":[]}
```

---

## Impact

* Arbitrary JavaScript execution
* DOM manipulation
* Session hijacking
* Credential theft
* Full client-side compromise

---

## Key Lessons Learned

* Reflected DOM XSS is both server-side and client-side
* `eval()` is extremely dangerous
* Escaping one character incorrectly can break security
* JSON reflection does not guarantee safety
* JavaScript sinks must never process untrusted input

---

## Dangerous JavaScript Sinks

Avoid using untrusted data with:

* `eval()`
* `setTimeout(string)`
* `setInterval(string)`
* `Function()`

---

## Final Summary

* Server reflects input into JSON
* Client-side JavaScript processes it unsafely
* Improper escaping enables context breaking
* `eval()` executes injected JavaScript
* High-impact reflected DOM-based XSS

 
