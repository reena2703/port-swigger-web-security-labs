# Web Security Academy – Referer-based Access Control

## Lab Details
Category: Access Control  
Level: Practitioner  
Status: Solved  

---

## Lab Description
This lab controls access to admin functionality using the `Referer` HTTP header.  
The backend trusts the Referer value without properly validating the user's role.

---

## Objective
Exploit the Referer-based access control to promote a normal user to administrator.

---

## Credentials Used

Administrator:
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
- Browser Developer Tools

---

## Solution Steps (Actual Exploitation Flow)

### Step 1: Capture Admin Role Upgrade Request
1. Log in using **administrator** credentials.
2. Navigate to the **admin panel**.
3. Upgrade the user `carlos` to admin.
4. Send the **role upgrade request** to **Burp Repeater**.

---

### Step 2: Switch to Normal User
1. Log out from the administrator account.
2. Log in using:
```

wiener:peter

```
3. Right-click → **Inspect**
4. Go to:
```

Application → Cookies

```
5. Copy the session cookie of the `wiener` account.

Example:
```

session=6lzRTOROgA3CJMHw9Lz4sprrq0sHlU4f

```

---

### Step 3: Replay Request with Wiener Session
1. Paste the `wiener` session cookie into the **Repeater request**.
2. Change the request parameter:
```

username=carlos

```
to:
```

username=wiener

```
3. Send the request.

---

## Result
- User `wiener` is promoted to administrator
- Lab is solved successfully 

---

## Vulnerability Identified
- Access control enforced using `Referer` header
- Backend trusts Referer without role validation
- Privilege escalation via request replay

---

## Key Takeaways
- Referer headers must never be used for authorization
- Access control must be enforced server-side
- Replaying admin requests with a low-privilege session can expose flaws

 

