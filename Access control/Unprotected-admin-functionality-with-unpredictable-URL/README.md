# PortSwigger Lab – Unprotected Admin Functionality with Unpredictable URL

## Lab Details
Category: Access Control  
Level: Apprentice  
Status: Solved  

---

## Lab Description
This lab contains an **unprotected admin panel** that is not linked anywhere in the application and uses an **unpredictable URL**.

Although the URL is not obvious, it is still disclosed within the client-side code, allowing attackers to discover and access sensitive functionality without authentication.

---

## Objective
- Discover the hidden admin panel URL
- Access the admin panel without authentication
- Delete the user `carlos`

---

## Tools Used
- Browser Developer Tools
- Burp Suite (optional)

---

## Solution Walkthrough

### Step 1: Inspect Page Source
Opened the lab home page and reviewed the page source using browser developer tools.

Observed embedded JavaScript that disclosed the admin panel URL, for example:
```js
var adminPath = '/admin-xyz123';
````

This reveals the supposedly “unpredictable” location of the admin panel.

---

### Step 2: Access the Admin Panel

Entered the discovered admin URL directly into the browser:

```
/admin-xyz123
```

The admin panel loaded successfully **without requiring authentication**, confirming missing access controls.

---

### Step 3: Delete the User

Used the admin interface to delete the user:

```
carlos
```

The lab was successfully solved.

---

## Impact

* Unauthenticated access to administrative functionality
* Full control over user management
* Security through obscurity completely bypassed

---

## Key Takeaways

* Hiding URLs does not provide real security
* Client-side code should never expose sensitive endpoints
* Admin functionality must always be protected by server-side access controls

 

 
