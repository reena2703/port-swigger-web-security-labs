# Cross-Site Scripting (XSS) – DOM-Based XSS
(Web Security Academy)

This lab demonstrates a DOM-based XSS vulnerability caused by unsafe manipulation of an anchor tag’s `href` attribute using jQuery.

---

## Lab: DOM XSS in jQuery Anchor Href Attribute Sink Using location.search

**Category:** Cross-site scripting  
**Type:** DOM-based XSS  
**Level:** Apprentice  
**Status:** Solved 

---

## What This Lab Is About

- The application uses **jQuery** to dynamically update a link
- User input is read from `location.search`
- The value is assigned directly to an anchor tag’s `href` attribute
- No validation or sanitization is applied
- This allows execution of JavaScript via a `javascript:` URL

---

## Vulnerable Flow

- **Source:** `location.search`
- **Sink:** jQuery `.attr("href", userInput)`

The code behaves like:
```js
$('a').attr('href', returnPath);
````

Because the `href` attribute is attacker-controlled, JavaScript URLs can be injected.

---

## What I Observed

1. Navigated to the **Submit feedback** page
2. Changed the `returnPath` parameter to a random string:

   ```
   /test123
   ```
3. Inspected the page
4. Found the value reflected inside the anchor tag:

```html
<a href="/test123">Back</a>
```

This confirmed the input was being directly inserted into the `href` attribute.

---

## Payload Used

```text
javascript:alert(document.cookie)
```

---

## Steps I Followed

1. Changed the URL parameter to:

   ```
   ?returnPath=javascript:alert(document.cookie)
   ```
2. Pressed **Enter**
3. Clicked the **Back** link
4. The browser executed the JavaScript URL
5. `alert(document.cookie)` was triggered

---

## Why This Worked

* `location.search` is fully user-controlled
* jQuery does not sanitize values assigned via `.attr()`
* `javascript:` URLs are executed when clicked
* No validation was applied to restrict URL schemes

---

## Impact

* Execution of arbitrary JavaScript
* Cookie theft
* Session hijacking
* Phishing via malicious links
* Client-side attacks without server interaction

---

## Key Lessons Learned

* DOM XSS can occur via HTML attributes, not just HTML content
* `href` attributes must be validated for safe URL schemes
* jQuery does **not** provide security by default
* `javascript:` URLs are dangerous and should be blocked
* Client-side logic is a common XSS attack surface

---

## Common Dangerous Patterns

Be cautious with:

* `.attr("href", userInput)`
* `.prop("href", userInput)`
* Any client-side redirect using untrusted input

---

## Final Summary

* DOM-based XSS via anchor `href`
* Source: `location.search`
* Sink: jQuery `.attr()`
* Payload uses `javascript:` scheme
* JavaScript executes on user interaction (click)

 
