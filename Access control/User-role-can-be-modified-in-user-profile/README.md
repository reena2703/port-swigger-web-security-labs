# PortSwigger Lab – User Role Can Be Modified in User Profile

## Lab Details
Category: Access Control  
Level: Apprentice  
Status: Solved 

---

## Lab Description
This lab contains an admin panel at `/admin` that is restricted to users with a specific role ID.

The vulnerability exists because the application allows users to modify their own **role identifier** through a profile update request, without enforcing proper server-side authorization.

---

## Objective
- Modify the user role to admin
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

---

## Solution Walkthrough

### Step 1: Log In and Access Profile
Logged in using the provided credentials and navigated to the **My account** page.

---

### Step 2: Update Email Address
Used the **Change email** feature and intercepted the request in Burp.

Observed that the response included the user’s role identifier:
```

"roleid": 1

````

This confirms that role information is exposed and processed client-side.

---

### Step 3: Modify Role in Repeater
Sent the email update request to **Burp Repeater**.

Modified the JSON request body by adding:
```json
"roleid": 2
````

Sent the modified request.

The response confirmed that the role had been updated to:

```
"roleid": 2
```

---

### Step 4: Access Admin Panel

Refreshed the browser and navigated to:

```
/admin
```

The admin panel loaded successfully, confirming privilege escalation.

---

### Step 5: Delete the User

Used the admin panel to delete the user:

```
carlos
```

The lab was successfully solved.

---

## Impact

* Unauthorized role modification
* Vertical privilege escalation
* Full administrative access
* User account deletion

---

## Key Takeaways

* User roles must never be modifiable by the client
* Authorization must be enforced server-side
* Exposing role identifiers increases attack surface
* Profile update endpoints are common escalation vectors
  
