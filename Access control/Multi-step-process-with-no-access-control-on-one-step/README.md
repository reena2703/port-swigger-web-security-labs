# Web Security Academy – Multi-step Process with No Access Control on One Step

## Lab Details
Category: Access Control  
Level: Practitioner  
Status: Solved 

---

## Lab Description
This lab contains an admin panel where changing a user’s role is handled through a multi-step process.  
One of the confirmation steps does not properly enforce access control, allowing privilege escalation.

---

## Objective
Exploit the broken multi-step role change process to promote a normal user to administrator.

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

### Step 1: Capture Admin Role Upgrade Requests
1. Log in using administrator credentials.
2. Navigate to the **admin panel**.
3. Upgrade the user `carlos` to admin.
4. Send the **role upgrade request** to **Burp Repeater**.
5. In the browser, a confirmation prompt appears (Yes / Confirm).
6. Click **Yes**.
7. Send this **confirmation request** to **Burp Repeater** as well.

At this point, **two requests** are stored in Repeater:
- Role upgrade request
- Confirmation request

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

### Step 3: Replace Session in Repeater
1. Paste the `wiener` session cookie into **both Repeater requests**.
2. Focus on the **second request** (confirmation request).

Request parameters:
```

action=upgrade
confirmed=true
username=carlos

```

3. Send the request using the new session.
4. Click **Follow redirection** if prompted.

---

### Step 4: Upgrade Wiener to Admin
1. Go back to the same request in Repeater.
2. Change:
```

username=carlos

```
to:
```

username=wiener

```

Final parameters:
```

action=upgrade&confirmed=true&username=wiener

```

3. Send the request.

---

### Step 5: Repeat for First Request
1. In the **first Repeater request**, also change:
```

username=carlos → username=wiener

```
2. Send the request again.

---

## Result
- User `wiener` is successfully promoted to administrator
- Lab is solved 

---

## Vulnerability Identified
- Missing access control on confirmation step
- Privilege escalation via request replay
- Multi-step process trusts client-side flow

---

## Key Takeaways
- Every step in a multi-step workflow must enforce authorization
- Confirmation endpoints are common access control bypass points
- Session swapping can expose broken privilege checks
- Never trust frontend logic for role changes

 
