# PortSwigger Lab – Password Brute-Force via Password Change

## Lab Details
Category: Server-Side Authentication – Other Mechanisms  
Level: Practitioner  
Status: Solved   

---

## Lab Description
This lab contains a **logic flaw in the password change functionality** that allows an attacker to brute-force a user’s current password.

Although the application attempts to protect accounts from brute-force attacks, subtle differences in server-side error messages reveal whether the supplied current password is correct.

By abusing this behavior, it is possible to enumerate Carlos’s password and take over his account.

---

## Objective
- Abuse the password change feature
- Brute-force Carlos’s current password
- Log in as Carlos
- Access the *My account* page

---

## Credentials
- Attacker account: `wiener : peter`
- Victim username: `carlos`

---

## Tools Used
- Burp Suite (Proxy, Intruder)
- Provided password wordlist

---

## Solution Walkthrough

### Step 1: Analyze Password Change Logic
Logged in using my own account and tested the **Change Password** functionality.

Observed the following server-side behavior:
- Wrong current password + matching new passwords → account lock
- Wrong current password + mismatched new passwords →  
  **Error: "Current password is incorrect"**
- Correct current password + mismatched new passwords →  
  **Error: "New passwords do not match"**

This difference in responses leaks whether the current password is valid.

---

### Step 2: Capture Password Change Request
Entered:
- Correct current password
- Two different new passwords

Intercepted the `POST /my-account/change-password` request and sent it to **Burp Intruder**.

---

### Step 3: Prepare the Brute-Force Attack
Modified the request as follows:

```

username=carlos
&current-password=§password§
&new-password-1=123
&new-password-2=abc

```

Key points:
- Username changed to `carlos`
- Payload position added to `current-password`
- New passwords intentionally set to different values

---

### Step 4: Configure Intruder
- Attack type: **Sniper**
- Payload: candidate password list
- Added **Grep Match** rule for:
```

New passwords do not match

```

This message only appears when the current password is correct.

---

### Step 5: Identify the Correct Password
Started the attack and reviewed the results.

Observed that **only one request** returned the message:
```

New passwords do not match

```

This confirmed that the payload used in that request was Carlos’s correct password.

---

### Step 6: Account Takeover
Logged out of my own account.

Logged in using:
- Username: `carlos`
- Password: identified password

Successfully accessed the **My account** page, solving the lab.

---

## Impact
- Password brute-force via business logic flaw
- Authentication bypass without rate-limiting
- Account takeover through error message leakage

---

## Key Takeaways
- Password change functionality is part of the authentication surface
- Error messages must not reveal authentication state
- Business logic flaws can bypass brute-force protections
- Server-side validation consistency is critical

 
