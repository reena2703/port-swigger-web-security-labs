# PortSwigger Lab – User ID Controlled by Request Parameter with Data Leakage in Redirect

## Lab Details
Category: Access Control  
Level: Apprentice  
Status: Solved  

---

## Lab Description
This lab contains a **horizontal privilege escalation vulnerability** where sensitive data is leaked inside the **response body of a redirect**.

Even though the application attempts to prevent unauthorized access by redirecting the user, it still includes confidential information in the response body before the redirect occurs.

---

## Objective
- Exploit IDOR on the account page
- Retrieve Carlos’s API key from a redirect response
- Submit the API key to solve the lab

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

Observed the request containing the user identifier:
```

/my-account?id=wiener

```

---

### Step 2: Send Request to Repeater
Sent the account page request to **Burp Repeater** for manual modification.

---

### Step 3: Modify the User ID Parameter
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

### Step 4: Inspect Redirect Response
The server responded with a redirect to the home page (HTTP 302).

However, upon inspecting the **response body**, it contained **Carlos’s API key**, despite the redirect.

---

### Step 5: Submit the API Key
Copied the leaked API key from the response body and submitted it to solve the lab.

---

## Impact
- Horizontal privilege escalation
- Sensitive data leakage via redirect responses
- API key disclosure

---

## Key Takeaways
- Redirects do not prevent data exposure
- Sensitive information must never be included in unauthorized responses
- Access control must be enforced before data is processed or returned
- Always inspect response bodies, even on redirects
 
