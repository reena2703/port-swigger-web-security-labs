# Cross-Site Scripting (XSS) – Event Handlers and `href` Attributes Blocked

(**Web Security Academy**)

This lab demonstrates an **advanced reflected XSS scenario** where **common execution vectors are blocked**, including:

* All JavaScript **event handlers**
* All **`href` attributes** on anchor tags

Despite these restrictions, XSS is still achievable by abusing **SVG animation elements** and **attribute-based execution** that does not rely on events or links.

---

## Lab: Reflected XSS with Event Handlers and `href` Attributes Blocked

**Category:** Cross-site scripting
**Context:** HTML injection with filtering
**Type:** Reflected XSS
**Protections Present:**

* Event handlers blocked
* Anchor `href` attributes blocked
* Only selected tags whitelisted

**Difficulty:** Expert
**Status:** Solved

---

## What This Lab Is About

This lab simulates a hardened filtering environment where:

* `<script>` tags are blocked
* `on*` event handlers are blocked
* `<a href="javascript:...">` vectors are blocked
* Only **specific SVG-related tags** are allowed

The goal is to **execute JavaScript when the victim clicks** on a visible element labeled **“Click”**, without using:

* Event handlers
* `href` attributes
* Inline scripts

---

## Vulnerable Flow

* **Source:** `search` query parameter
* **Sink:** Reflected HTML output
* **Trigger:** User click (simulated victim)
* **Execution Context:** SVG animation
* **Sensitive Action:** JavaScript execution (`alert()`)

---

## Key Constraint

The simulated user **will only click elements containing the word “Click”**.

This forces the exploit to:

* Be user-driven
* Appear legitimate
* Contain visible clickable text

---

## Exploit Payload

### Final Exploit URL

```text
https://YOUR-LAB-ID.web-security-academy.net/?search=%3Csvg%3E%3Ca%3E%3Canimate+attributeName=href+values=javascript:alert(1)+begin=click%3E%3C/animate%3EClick%3C/a%3E%3C/svg%3E
```

---

## How the Payload Works

### Breakdown

```html
<svg>
  <a>
    <animate 
      attributeName="href"
      values="javascript:alert(1)"
      begin="click">
    </animate>
    Click
  </a>
</svg>
```

### Why This Bypasses Filters

* No event handlers (`onclick`, `onload`, etc.)
* No direct `href` attribute
* Uses **SVG `<animate>`** to dynamically set `href`
* Execution occurs **after user interaction**
* SVG animation attributes are often overlooked by filters

---

## Steps I Followed

1. Tested standard XSS payloads (`<script>`, `onerror`, `href=javascript:`)
2. Confirmed:

   * Event handlers were blocked
   * Anchor `href` attributes were blocked
3. Identified that **SVG tags were still allowed**
4. Tested SVG animation-related elements
5. Used `<animate>` to modify the `href` attribute dynamically
6. Set `begin=click` to trigger on user interaction
7. Added visible text labeled **“Click”**
8. Delivered the payload via the reflected search parameter
9. Simulated victim clicked the element
10. `alert(1)` executed successfully
11. Lab marked as solved

---

## Why This Worked

* Filters focused on **static attributes**, not animated ones
* SVG allows **dynamic attribute mutation**
* The execution occurred **after rendering**
* No blacklisted syntax was directly present in the HTML
* User interaction satisfied lab constraints

---

## Impact

* JavaScript execution despite strong filtering
* Demonstrates bypass of:

  * Event handler blocking
  * `href` blocking
* Confirms SVG as a powerful XSS attack surface

---

## Key Lessons Learned

* Blocking `on*` events is not enough
* SVG introduces alternate execution paths
* Dynamic attribute mutation can bypass sanitization
* Click-based XSS is still dangerous
* “Allowed tags” lists are fragile

---

## Defensive Takeaways

To prevent this vulnerability:

* Disable SVG where not required
* Sanitize SVG elements and attributes strictly
* Avoid rendering user input as raw HTML
* Use proper output encoding, not blacklist-based filtering
* Treat SVG as active content

---

## Final Summary

* Reflected XSS achieved without events or `href`
* SVG animation used as an execution primitive
* User interaction triggered payload
* Demonstrates advanced filter bypass techniques
* Highlights the dangers of partial HTML sanitization

  
