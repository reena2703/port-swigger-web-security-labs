
# PortSwigger Lab – Password Reset Broken Logic

## Lab Details
Category: Server-Side Authentication (Password Reset)  
Level: Apprentice  
Status: Solved ✅  

---

## What This Lab Is About
This lab demonstrates a **server-side logic flaw in the password reset mechanism**.

Although the application uses a password reset token, the backend **does not properly validate the token when the new password is submitted**. Because of this, an attacker can reset another user’s password without having a valid reset token.

The vulnerability exists entirely on the **server side** and is caused by broken validation logic.

---

## Goal of the Lab
- Exploit the broken password reset logic
- Reset Carlos’s password
- Log in and access his **My account** page

---

## Given Credentials
- My account: `wiener : peter`
- Victim username: `carlos`

---

## Tools Used
- Burp Suite
  - Proxy
  - Repeater
- Browser
- Built-in email client

---

## How I Solved It

### 1. Observing the Password Reset Flow
With Burp running, I clicked **Forgot your password?** and entered my own username.

- I accessed the password reset email using the email client.
- The reset link contained a token as a URL parameter.
- I reset my password successfully to observe how the process works.

---

### 2. Analyzing the Reset Request
In **Proxy → HTTP history**, I reviewed the password reset requests.

I noticed that:
- The reset token is passed as a URL parameter.
- The `POST /forgot-password` request contains the **username as a hidden input**.

I sent the password reset request to **Burp Repeater** for further testing.

---

### 3. Testing Token Validation
In Burp Repeater, I deleted the value of the `temp-forgot-password-token` parameter from:
- The URL
- The request body

I sent the request and observed that the password reset **still worked**, confirming that the token was **not being validated** by the server.

---

### 4. Resetting Carlos’s Password
I requested another password reset for my own account and sent the reset request to Burp Repeater again.

Then I:
- Removed the reset token value
- Changed the `username` parameter to `carlos`
- Set a new password of my choice
- Sent the request

The server accepted the request and reset Carlos’s password.

---

### 5. Logging In as Carlos
Using the new password, I logged in as Carlos and accessed the **My account** page, completing the lab.

---

## Why This Is a Server-Side Issue
The vulnerability exists because the backend:

- Does not validate the password reset token
- Trusts user-controlled input (username)
- Applies the password change without proper authorization checks

This allows attackers to reset passwords for other users.

---

## Key Takeaways
- Password reset tokens must always be validated server-side
- Sensitive actions should never rely on hidden form fields
- Broken logic can be just as dangerous as missing authentication
- Password reset functionality is a high-value attack target

---

## Impact
- Unauthorized password resets
- Full account takeover
- Complete loss of account security

---

## Why I’m Documenting This
I’m documenting this lab as:
- A personal learning record
- Proof of hands-on experience with server-side authentication flaws
- A reference for interviews and future review
```

 

 
