# PortSwigger Lab – User ID Controlled by Request Parameter

## Lab Details
Category: Access Control  
Level: Apprentice  
Status: Solved  

---

## Lab Description
This lab contains a **horizontal privilege escalation vulnerability** on the user account page.

The application identifies which account to display using a user-controlled request parameter, allowing one user to access another user’s sensitive data.

---

## Objective
- Exploit IDOR on the account page
- Access Carlos’s account data
- Retrieve and submit Carlos’s API key

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

### Step 1: Access Own Account
Logged in using the provided credentials and navigated to the **My account** page.

Observed that the URL contained a user-controlled parameter:
```

/my-account?id=wiener

```

---

### Step 2: Send Request to Repeater
Sent the request for the account page to **Burp Repeater** for manual modification.

---

### Step 3: Modify User ID Parameter
In Burp Repeater, changed the `id` parameter from:
```

id=wiener

```
to:
```

id=carlos

```

Sent the modified request.

---

### Step 4: Retrieve Sensitive Data
The response returned **Carlos’s account page**, including his **API key**.

Extracted the API key and submitted it to complete the lab.

---

## Impact
- Horizontal privilege escalation
- Unauthorized access to sensitive user data
- API key disclosure

---

## Key Takeaways
- Object references must be properly authorized
- User-controlled IDs are a common source of IDOR vulnerabilities
- Authentication does not equal authorization
- Sensitive data should never be exposed without access checks

 
