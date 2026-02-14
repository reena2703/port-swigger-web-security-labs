# Access Control – Server-Side Security (Web Security Academy)

## What is Access Control?

Access control is the application of constraints on **who** or **what** is authorized to perform actions or access resources.

In web applications, access control depends on:

- **Authentication** – verifies who the user is
- **Session management** – tracks requests made by that user
- **Authorization (Access Control)** – decides what the user is allowed to do

Broken access control occurs when users can:
- Access resources they shouldn’t
- Perform actions beyond their privilege level
- Modify identifiers to access other users’ data

Access control flaws are **very common** and often lead to **critical vulnerabilities**.

---

## What I Learned from the Access Control Labs (13 Labs)

---

## 1. Unprotected Admin Functionality
**Lesson learned**
- Admin panels may be completely unprotected
- Sensitive paths can be leaked via `robots.txt`

**Key takeaway**
- Always check `/robots.txt`
- Never rely on “hidden URLs” for security

---

## 2. Unprotected Admin Functionality with Unpredictable URL
**Lesson learned**
- Even “random” admin URLs can be exposed in client-side code

**Key takeaway**
- Always inspect page source and JavaScript files
- Client-side code should never contain sensitive paths

---

## 3. User Role Controlled by Request Parameter
**Lesson learned**
- User roles stored in cookies can be forged

**Key takeaway**
- Never trust client-controlled cookies for authorization
- Authorization must be enforced server-side

---

## 4. User Role Can Be Modified in User Profile
**Lesson learned**
- APIs may expose sensitive fields like `roleid`
- Users can escalate privileges by modifying request bodies

**Key takeaway**
- Never allow users to modify authorization-related fields
- Always whitelist allowed parameters on the server

---

## 5. User ID Controlled by Request Parameter
**Lesson learned**
- Horizontal privilege escalation via ID manipulation

**Key takeaway**
- Changing `id=wiener` → `id=carlos` can expose other users’ data
- Always validate ownership server-side

---

## 6. User ID Controlled by Request Parameter (Unpredictable IDs)
**Lesson learned**
- GUIDs do not prevent IDOR if they are discoverable

**Key takeaway**
- “Unpredictable” IDs are not access control
- Authorization checks are still required

---

## 7. User ID Controlled by Request Parameter with Data Leakage in Redirect
**Lesson learned**
- Sensitive data can be leaked inside redirect responses

**Key takeaway**
- Always inspect response bodies, even on 302 redirects
- Front-end redirects do not stop backend data exposure

---

## 8. User ID Controlled by Request Parameter with Password Disclosure
**Lesson learned**
- Applications may expose passwords in responses or hidden fields

**Key takeaway**
- Never prefill passwords (even masked)
- Sensitive data should never be returned to the client

---

## 9. Insecure Direct Object References (IDOR)
**Lesson learned**
- Files stored with predictable names can expose sensitive data

**Key takeaway**
- Check static file paths and numbering patterns
- Direct object access must be protected

---

## 10. URL-Based Access Control Can Be Circumvented
**Lesson learned**
- Front-end path blocking can be bypassed using headers like:
  - `X-Original-URL`

**Key takeaway**
- Front-end security controls are not sufficient
- Back-end must enforce access rules

---

## 11. Method-Based Access Control Can Be Circumvented
**Lesson learned**
- Authorization based on HTTP method can be bypassed

**Key takeaway**
- Try changing methods:
  - POST → GET
  - POST → POSTX
- Authorization should not depend on HTTP method alone

---

## 12. Multi-Step Process with No Access Control on One Step
**Lesson learned**
- Some steps in multi-step workflows may lack authorization

**Key takeaway**
- Test every step individually
- Skipping or replaying confirmation steps can lead to privilege escalation

---

## 13. Referer-Based Access Control
**Lesson learned**
- Applications may rely on the `Referer` header for authorization

**Key takeaway**
- Referer headers are user-controlled
- Never use Referer for access control decisions

---

## Overall Access Control Testing Checklist

When testing access control, always try:

- Changing user IDs (`id`, `user`, `account`)
- Modifying role-related parameters (`roleid`, `admin`, `isAdmin`)
- Replaying admin requests with a normal user session
- Removing or faking headers (`Referer`, `X-Original-URL`)
- Changing HTTP methods
- Accessing endpoints directly (`/admin`, `/delete`, `/upgrade`)
- Inspecting redirects and response bodies

---

## Final Summary

- Access control must be enforced **server-side**
- Client-side controls are **not security**
- Never trust:
  - Cookies
  - Headers
  - Hidden fields
  - HTTP methods
- Every request must be authorized independently

---

## Status
Access Control labs completed  
Strong understanding of privilege escalation & IDOR flaws
 
