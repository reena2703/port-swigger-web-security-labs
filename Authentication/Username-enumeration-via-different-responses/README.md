# PortSwigger Lab – Username Enumeration via Different Responses

## Lab Details
Category: Server-Side Authentication  
Level: Apprentice  
Status: Solved 

---

## What This Lab Is About
This lab focuses on a **server-side authentication vulnerability** where the backend returns different responses depending on whether a username exists.

Even though the login page looks normal from the frontend, the **server leaks information through its responses**. This makes it possible to:

- Identify valid usernames
- Brute-force the password for an existing user
- Log in without authorization

The issue exists entirely on the **server side** — the client is not doing anything special.

---

## Goal of the Lab
- Find a valid username by analyzing server responses
- Brute-force the password for that user
- Log in and access the account page

---

## Tools Used
- Burp Suite
  - Proxy
  - Intruder (Sniper attack)
- Provided username wordlist
- Provided password wordlist

---

## How I Solved It

### 1. Intercepting the Login Request
I started Burp and submitted random login credentials.  
Using **Proxy → HTTP history**, I located the `POST /login` request and sent it to **Burp Intruder**.

This request is processed by the **server-side authentication logic**, which is where the vulnerability exists.

---

### 2. Enumerating a Valid Username
In Burp Intruder, I placed a payload position on the `username` parameter and kept the password static:

```

username=§test§&password=test

```

- Attack type: Sniper  
- Payload: candidate usernames  

After running the attack, I sorted the results by **response length**.

Most responses contained:
```

Invalid username

```

One response was different and returned:
```

Incorrect password

```

This difference means the **server recognized the username**, even though the password was wrong.  
That confirmed a valid username, which I noted down.

---

### 3. Brute-Forcing the Password
Next, I fixed the username and placed the payload position on the `password` parameter:

```

username=identified-user&password=§password§

```

I ran another Sniper attack using the candidate password list.

When reviewing the results:
- Almost every request returned **HTTP 200**
- One request returned **HTTP 302**

The **302 redirect** indicates a successful login, meaning that payload was the correct password.

---

### 4. Logging In
Using the valid username and password, I logged in through the normal login form and accessed the account page, completing the lab.

---

## Why This Is a Server-Side Issue
The vulnerability occurs because the backend authentication logic:

- Distinguishes between “invalid username” and “wrong password”
- Returns different response messages and lengths
- Uses different status codes when login succeeds

Even small server-side differences like these are enough to break authentication security.

---

## Key Takeaways
- Authentication error messages should always be **generic**
- The server should respond the same way for:
  - Invalid username
  - Invalid password
- Username enumeration makes brute-force attacks much more efficient
- This issue is easy to miss but has a serious security impact

---

## Why I’m Documenting This
I’m keeping this write-up as:
- A personal learning record
- Proof of hands-on experience with server-side vulnerabilities
- A reference for interviews and future review
```
 
 
Just say 👍

