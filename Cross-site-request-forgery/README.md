# Cross-Site Request Forgery (CSRF) – Lab Learnings

This repository documents key lessons learned from completing all **12 Cross-Site Request Forgery (CSRF)** labs on **:contentReference[oaicite:0]{index=0}**.

The focus is not just *how* each lab was solved, but **what security assumptions fail**, **why defenses break**, and **how attackers think in real-world scenarios**.

---

## Lab 1 – CSRF vulnerability with no defenses

### What I Learned
- A state-changing request without CSRF protection is trivially exploitable
- Browsers automatically attach session cookies to cross-site requests
- HTML forms alone are enough to perform CSRF

### Key Insight
> If an action relies only on cookies for authentication, it is vulnerable by default.

---

## Lab 2 – CSRF where token validation depends on request method

### What I Learned
- CSRF tokens must be validated on **all HTTP methods**
- Switching from POST to GET can bypass incomplete token checks

### Key Insight
> Security controls tied to “expected behavior” instead of *actual enforcement* are fragile.

---

## Lab 3 – CSRF where token validation depends on token being present

### What I Learned
- Some applications only validate the token **if it exists**
- Removing the token entirely can bypass validation logic

### Key Insight
> Optional security checks are not security checks.

---

## Lab 4 – CSRF where token is not tied to user session

### What I Learned
- CSRF tokens must be bound to the user session
- A valid token reused across users defeats the purpose

### Key Insight
> A CSRF token without context is just a random string.

---

## Lab 5 – CSRF where token is tied to non-session cookie

### What I Learned
- Tokens stored in cookies can be attacker-controlled
- CSRF protection fails if the attacker can set both token and request

### Key Insight
> Double-submit cookies are dangerous without strict integrity guarantees.

---

## Lab 6 – CSRF where token is duplicated in cookie

### What I Learned
- Matching token-in-body with token-in-cookie is insufficient
- Attackers can control both values

### Key Insight
> Comparing attacker-controlled values proves nothing.

---

## Lab 7 – CSRF where Referer validation depends on header being present

### What I Learned
- Some applications trust Referer **only if it exists**
- Browsers can be instructed to suppress the Referer header

### Key Insight
> Missing headers should be treated as suspicious, not trusted.

---

## Lab 8 – CSRF with broken Referer validation

### What I Learned
- Naive substring matching in Referer validation is bypassable
- The trusted domain can be injected into query strings

### Key Insight
> String containment ≠ origin validation.

---

## Lab 9 – CSRF where Origin validation is implemented incorrectly

### What I Learned
- Origin headers must be strictly validated
- Partial matches or weak parsing logic allow bypasses

### Key Insight
> Origin checks must be exact, not approximate.

---

## Lab 10 – CSRF where SameSite=Lax bypassed via method override

### What I Learned
- SameSite=Lax still allows some cross-site requests
- Method override techniques can re-enable CSRF

### Key Insight
> Cookie flags reduce risk, they do not eliminate it.

---

## Lab 11 – CSRF where SameSite=Strict bypassed via client-side redirect

### What I Learned
- SameSite=Strict can be bypassed with same-site redirects
- Client-side JavaScript behavior matters for CSRF

### Key Insight
> Browser navigation logic can defeat cookie-based defenses.

---

## Lab 12 – CSRF with flawed defense-in-depth

### What I Learned
- Multiple weak defenses do not equal one strong defense
- Misconfigured layers still collapse together

### Key Insight
> Defense-in-depth only works if *each layer actually works*.

---

## Core CSRF Lessons Across All Labs

- CSRF tokens are mandatory for state-changing actions
- Tokens must be:
  - Required
  - Session-bound
  - Server-validated
- Referer and Origin headers are **not reliable alone**
- SameSite cookies are **mitigations, not solutions**
- Client-side behavior (redirects, JS, browser policies) affects security
- GET requests must never perform state changes

---

## Defensive Best Practices

- Enforce CSRF tokens on all state-changing endpoints
- Bind tokens to user sessions
- Reject requests with missing or invalid tokens
- Avoid state changes via GET
- Validate Origin strictly
- Treat browser headers as untrusted input
- Do not rely on cookie flags alone

---

## Final Takeaway

> CSRF is not about tricking the server —  
> it’s about abusing the browser’s trust model.

Understanding how browsers send cookies, headers, and redirects
is the key to both **exploiting** and **preventing** CSRF.

---

 All 12 CSRF labs completed  
 Focus: real-world exploitability, not just lab solutions
