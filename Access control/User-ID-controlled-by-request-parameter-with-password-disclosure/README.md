# PortSwigger Lab – User ID Controlled by Request Parameter with Password Disclosure

## Lab Details
Category: Access Control  
Level: Apprentice  
Status: Solved 

---

## Lab Description
This lab contains a **horizontal privilege escalation vulnerability** combined with **sensitive data disclosure**.

The user account page exposes the current user’s password in a masked input field. By modifying the user identifier in the request, it is possible to retrieve another user’s password, including the administrator’s.

---

## Objective
- Exploit IDOR on the account page
- Retrieve the administrator’s password
- Log in as administrator
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

### Step 1: Access Own Account
Logged in using the provided credentials and navigated to the **My account** page.

Observed that the account page includes the current password in a masked input field.

---

### Step 2: Modify User ID Parameter
Changed the `id` parameter in the URL from:
```

id=wiener

```
to:
```

id=administrator

```

Loaded the page and clicked **Update password**.

---

### Step 3: Inspect the Password Disclosure
Intercepted the request to:
```

/my-account/change-password

```

Viewed the response in Burp and observed that it contained the **administrator’s current password** in plaintext.

---

### Step 4: Admin Account Takeover
Logged out and authenticated as:
```

administrator : <retrieved-password>

```

Successfully accessed the administrator account.

---

### Step 5: Delete the User
Navigated to the admin panel and deleted the user:
```

carlos

```

The lab was successfully solved.

---

## Impact
- Password disclosure
- Horizontal and vertical privilege escalation
- Administrator account compromise
- User account deletion

---

## Key Takeaways
- Passwords should never be exposed or prefilled, even in masked fields
- Access control must be enforced on every user-specific request
- IDOR vulnerabilities often lead to complete account compromise
- Sensitive data exposure dramatically increases attack impact

 
