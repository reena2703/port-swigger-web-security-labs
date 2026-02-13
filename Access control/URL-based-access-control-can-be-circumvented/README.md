# PortSwigger Lab – URL-based Access Control Can Be Circumvented

## Lab Details
Category: Access Control  
Level: Practitioner  
Status: Solved  

---

## Lab Description
This lab contains an **access control bypass** where a front-end system blocks access to the `/admin` path.  
However, the back-end application supports the `X-Original-URL` HTTP header, which can be abused to bypass the restriction.

---

## Objective
- Bypass the front-end URL restriction
- Access the admin panel
- Delete the user `carlos`

---

## Tools Used
- Burp Suite (Proxy & Repeater)

---

## Solution Walkthrough

### Step 1: Identify the Block
Tried to access:
```

/admin

```
Received a blocked response.

The response was very plain, indicating that a **front-end system (reverse proxy)** was blocking the request.

---

### Step 2: Test Back-end URL Handling
Sent the blocked request to **Burp Repeater**.

Modified the request:
- Changed the request line path to `/`
- Added the following header:
```

X-Original-URL: /invalid

```

Received a **404 Not Found** response, confirming that the back-end application processes the path from the `X-Original-URL` header.

---

### Step 3: Access the Admin Panel
Updated the header to:
```

X-Original-URL: /admin

```

Sent the request and successfully accessed the **admin panel**.

---

### Step 4: Delete the User Carlos
Modified the request:
- Real URL query string:
```

?username=carlos

```
- Header value:
```

X-Original-URL: /admin/delete

```

Sent the request and successfully deleted the user `carlos`.

---

## Impact
- URL-based access control bypass
- Unauthorized admin panel access
- Privilege escalation
- User deletion without authentication

---

## Key Takeaways
- Front-end security controls can often be bypassed
- Back-end systems may trust special headers like `X-Original-URL`
- Access control must be enforced server-side
- Never rely solely on reverse proxies for authorization

 
