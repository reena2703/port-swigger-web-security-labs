# CSRF – Token Validation Depends on Token Being Present

(**Web Security Academy**)

This lab demonstrates a **broken CSRF protection mechanism** where the application only validates the CSRF token **if it is present**, but **accepts the request entirely when the token is missing**.

---

## Lab: CSRF Where Token Validation Depends on Token Being Present

**Category:** Cross-Site Request Forgery (CSRF)
**Defense Type:** CSRF token (flawed implementation)
**Difficulty:** Practitioner
**Tools Used:** Burp Suite Community Edition
**Status:** Solved

---

## What This Lab Is About

The application attempts to protect the **email change functionality** using a CSRF token. However:

* If the CSRF token is **invalid** → request is rejected 
* If the CSRF token is **missing** → request is accepted 

This creates a classic **logic flaw** in CSRF validation.

---

## Target Functionality

Endpoint:

```
POST /my-account/change-email
```

Expected parameters:

* `email`
* `csrf` (optional, but incorrectly enforced)

---

## Vulnerable Behavior

| CSRF Token State  | Result       |
| ----------------- | ------------ |
| Valid token       | Accepted     |
| Invalid token     | Rejected     |
| **Missing token** | **Accepted** |

This means an attacker can simply **omit the CSRF token** and bypass protection entirely.

---

## Vulnerable Flow

1. Victim logs in
2. Victim visits attacker-controlled page
3. Malicious form submits request **without csrf parameter**
4. Browser includes victim’s cookies
5. Server processes the request
6. Victim’s email is changed

---

## CSRF Exploit Payload (Community Edition)

Since **Burp Suite Community Edition** does not support automatic CSRF PoC generation, the exploit was crafted **manually**.

```html
<form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="attacker@evil-user.net">
</form>

<script>
    document.forms[0].submit();
</script>
```

### Key Point

 **No `csrf` parameter is included at all**

---

## Steps I Followed (Community Edition)

1. Logged in using the provided credentials:

   ```
   wiener:peter
   ```

2. Changed the email address normally

3. Captured the request in **Burp Proxy → HTTP history**

4. Sent the request to **Burp Repeater**

5. Observed:

   * Modifying the CSRF token → request rejected

6. Deleted the `csrf` parameter entirely

7. Sent the request again

8. Request was **accepted**

9. Copied the request URL

10. Created a manual CSRF HTML form **without the csrf field**

11. Uploaded the exploit to the **exploit server**

12. Tested it using **View exploit**

13. Changed the email value to avoid matching my own

14. Clicked **Deliver exploit to victim**

15. Victim’s email was changed

16. Lab marked as solved

---

## Why This Worked

* CSRF validation was conditional
* Server logic assumed:

  > “If token exists → validate it”
* Missing token bypassed validation entirely
* Browser automatically sent authenticated cookies

This is a **logic flaw**, not a cryptographic failure.

---

## Impact

An attacker can:

* Bypass CSRF protections
* Perform unauthorized account changes
* Exploit authenticated users silently
* Chain with XSS for full account takeover

Severity: **High**

---

## Key Lessons Learned

* CSRF tokens must be **mandatory**
* Optional security controls are ineffective
* Validation logic is as important as implementation
* Burp Suite Community Edition is sufficient
* Always test missing, not just invalid, parameters

---

## Defensive Takeaways

To fix this vulnerability:

* Reject requests **without** CSRF tokens
* Enforce token presence server-side
* Validate token for **all** state-changing requests
* Combine with SameSite cookies
* Add Origin / Referer checks

---

## Final Summary

* CSRF token only validated when present
* Token omission bypasses protection
* Manual HTML exploit used
* No JavaScript required
* Exploited using Burp Suite Community Edition
* Victim’s email changed without consent

 
