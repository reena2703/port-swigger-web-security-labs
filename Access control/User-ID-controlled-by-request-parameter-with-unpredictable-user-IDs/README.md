# PortSwigger Lab – User ID Controlled by Request Parameter (Unpredictable User IDs)

## Lab Details
Category: Access Control  
Level: Apprentice  
Status: Solved

---

## Lab Description
This lab contains a **horizontal privilege escalation vulnerability**, but instead of predictable usernames, the application uses **GUIDs** to identify users.

Although the identifiers appear random, they are still exposed elsewhere in the application, making it possible to access another user’s account.

---

## Objective
- Discover Carlos’s user GUID
- Exploit IDOR using the GUID
- Retrieve and submit Carlos’s API key

---

## Credentials
- User account: `wiener : peter`

---

## Tools Used
- Browser
- Burp Suite (Proxy / Repeater)

---

## Solution Walkthrough

### Step 1: Discover Carlos’s User ID
Browsed the blog posts and found a post authored by **Carlos**.

Clicked on Carlos’s name and observed that the URL contained his user identifier:
```

/blogs?userId=GUID-HERE

```

Saved this **GUID**, which uniquely identifies Carlos’s account.

---

### Step 2: Access Own Account
Logged in using the provided credentials and navigated to the **My account** page.

Observed the request:
```

/my-account?id=OWN-GUID

```

---

### Step 3: Modify the User ID Parameter
Sent the account page request to **Burp Repeater**.

Replaced the `id` parameter value with Carlos’s GUID:
```

id=CARLOS-GUID

```

Sent the modified request.

---

### Step 4: Retrieve Sensitive Data
The response returned Carlos’s account details, including his **API key**.

Extracted the API key and submitted it to complete the lab.

---

## Impact
- Horizontal privilege escalation
- Sensitive data exposure
- IDOR despite “unpredictable” identifiers

---

## Key Takeaways
- Using GUIDs does not prevent IDOR vulnerabilities
- Authorization must be enforced on every object access
- User identifiers should never be trusted just because they look random
- Data exposure often occurs through indirect references

 
