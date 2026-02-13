# PortSwigger Lab – Insecure Direct Object References

## Lab Details
Category: Access Control  
Level: Apprentice  
Status: Solved

---

## Lab Description
This lab contains an **Insecure Direct Object Reference (IDOR)** vulnerability.

User chat transcripts are stored directly on the server’s file system and are accessed using **static, predictable URLs**. There are no access controls preventing users from viewing other users’ chat logs.

---

## Objective
- Access another user’s chat transcript
- Retrieve Carlos’s password
- Log in as Carlos

---

## Tools Used
- Browser

---

## Solution Walkthrough

### Step 1: Use the Live Chat Feature
Opened the **Live chat** tab and sent a message.

Clicked **View transcript**, which loaded a chat transcript file.

---

### Step 2: Analyze the Transcript URL
Observed that the transcript was accessed via a static URL similar to:
```

/download-transcript/5.txt

```

Noticed that the filename followed an **incrementing numeric pattern**.

---

### Step 3: Exploit the IDOR
Modified the filename in the URL to:
```

/download-transcript/1.txt

```

Loaded the file and found a chat transcript belonging to another user.

---

### Step 4: Retrieve Sensitive Data
The transcript contained **Carlos’s password** in plaintext.

Copied the credentials.

---

### Step 5: Account Takeover
Returned to the main lab page and logged in using the stolen credentials.

Successfully accessed Carlos’s account and solved the lab.

---

## Impact
- Insecure Direct Object Reference
- Sensitive data exposure
- Account takeover

---

## Key Takeaways
- Static file references must always be protected
- Predictable object identifiers lead to IDOR vulnerabilities
- Sensitive information should never be stored in plaintext
- Access control must be enforced at the file system level

 
