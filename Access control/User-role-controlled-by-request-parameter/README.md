# PortSwigger Lab – User Role Controlled by Request Parameter

## Lab Details
Category: Access Control  
Level: Apprentice  
Status: Solved  

---

## Lab Description
This lab contains an admin panel at `/admin`, but access control is implemented insecurely using a **client-side cookie**.

The application determines whether a user is an administrator based on a forgeable cookie value, allowing attackers to escalate privileges by modifying it.

---

## Objective
- Escalate privileges to admin
- Access the admin panel
- Delete the user `carlos`

---

## Credentials
- User account: `wiener : peter`

---

## Tools Used
- Burp Suite
  - Proxy
  - Repeater
- Browser Developer Tools

---

## Solution Walkthrough

### Step 1: Attempt to Access Admin Panel
Navigated directly to:
```

/admin

```

Access was denied, confirming that admin privileges are required.

---

### Step 2: Intercept Login Response
Opened the login page and turned **Intercept ON** in Burp Proxy.

Logged in using:
```

wiener : peter

```

Intercepted the **login response** and observed the following cookie being set:
```

Admin=false

```

This indicates that admin privileges are controlled entirely by a client-side cookie.

---

### Step 3: Test Cookie Manipulation in Repeater
Sent the intercepted response to **Burp Repeater**.

- First request: Sent as-is (`Admin=false`)
- Second request: Modified the cookie to:
```

Admin=true

```

After sending the modified request, the response confirmed admin-level access.

---

### Step 4: Modify Cookie in Browser
Returned to the browser and opened **Developer Tools → Application → Cookies**.

Manually changed:
```

Admin=false → Admin=true

```

Reloaded the page and observed that the **Admin panel option** now appeared.

---

### Step 5: Delete the User
Accessed the admin panel at:
```

/admin

```

Deleted the user:
```

carlos

```

The lab was successfully solved.

---

## Impact
- Privilege escalation via client-side manipulation
- Unauthorized access to admin functionality
- User account deletion

---

## Key Takeaways
- Authorization logic must never rely on client-side data
- Cookies can be modified easily by attackers
- Role checks must be enforced server-side
- This vulnerability enables full vertical privilege escalation

 
