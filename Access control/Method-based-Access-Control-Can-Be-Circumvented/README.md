# PortSwigger Lab – Method-based Access Control Can Be Circumvented

## Lab Details
Category: Access Control  
Level: Practitioner  
Status: Solved  

---

## Lab Description
This lab relies on HTTP method-based access control.  
A normal user should not be able to perform admin actions, but flawed logic allows privilege escalation by changing the request method.

---

## Objective
- Capture an admin-only request
- Replay it as a normal user
- Bypass access control by changing the HTTP method
- Promote yourself to administrator

---

## Credentials Used
Admin:
```

administrator:admin

```

User:
```

wiener:peter

```

---

## Tools Used
- Burp Suite (Proxy & Repeater)

---

## Solution Steps

### Step 1: Login as Administrator
Log in using admin credentials:
```

administrator:admin

```

Go to the **admin panel**.

Upgrade the role of user `carlos`.

Send the **admin role upgrade request** to **Burp Repeater**.

---

### Step 2: Switch to Normal User
Log out from the admin account.

Log in using normal user credentials:
```

wiener:peter

```

Enable Burp Proxy interception.

Capture any request and copy the **session cookie** for the `wiener` user, for example:
```

session=6lzRTOROgA3CJMHw9Lz4sprrq0sHlU4f

```

---

### Step 3: Replay Admin Request with User Session
Go back to **Burp Repeater**.

Paste the `wiener` session cookie into the previously saved **admin upgrade request**.

Send the request.

Response:
```

Unauthorized

```

This confirms that access control is enforced for standard requests.

---

### Step 4: Bypass Method-Based Access Control
In Burp Repeater:

- Right-click the request
- Select **Change request method**

Modify the request to:
```

username=wiener&action=upgrade HTTP/2

```

Send the request.

---

### Step 5: Successful Bypass
Response received:
```

HTTP/2 302 Found
Location: /admin
X-Frame-Options: SAMEORIGIN
Content-Length: 0

```

This indicates the request was accepted.

---

## Result
- User `wiener` is successfully promoted to **administrator**
- Lab is solved 

---

## Vulnerability
- Method-based access control bypass
- Privilege escalation

---

## Key Takeaways
- Access control must not rely on HTTP methods
- Authorization checks must be consistent for all methods
- Changing request methods (POST → GET) can bypass weak protections
- Always test method manipulation during access control testing

