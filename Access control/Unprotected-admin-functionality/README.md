# PortSwigger Lab – Unprotected Admin Functionality

## Lab Details
Category: Access Control  
Level: Apprentice  
Status: Solved  

---

## Lab Description
This lab contains an **unprotected admin panel** that is directly accessible without authentication.

Sensitive functionality is exposed simply because the application relies on *security through obscurity*, assuming users will not discover the admin URL.

---

## Objective
- Discover the admin panel
- Access it without authentication
- Delete the user `carlos`

---

## Tools Used
- Browser
- Manual URL manipulation

---

## Solution Walkthrough

### Step 1: Check robots.txt
Navigated to:
```

/robots.txt

```

Observed a `Disallow` entry that revealed the location of the admin panel:

```

/administrator-panel

```

This indicates that the admin functionality exists but is not properly protected.

---

### Step 2: Access the Admin Panel
Replaced `/robots.txt` in the browser URL with:
```

/administrator-panel

```

The admin panel loaded **without requiring authentication**, confirming missing access control.

---

### Step 3: Delete the User
Used the admin interface to delete the user:
```

carlos

```

The lab was successfully solved.

---

## Impact
- Unauthenticated access to admin functionality
- Full administrative control without login
- User account deletion

---

## Key Takeaways
- Admin panels must always enforce authentication and authorization
- `robots.txt` should never be treated as a security control
- Sensitive endpoints should not be discoverable or publicly accessible

 
