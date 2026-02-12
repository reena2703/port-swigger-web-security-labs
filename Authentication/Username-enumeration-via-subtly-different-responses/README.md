# PortSwigger Lab – Username Enumeration via Subtly Different Responses

## Lab Details
Category: Server-Side Authentication (Password-Based)  
Level: Practitioner  
Status: Solved   

---

## What This Lab Is About
This lab demonstrates a **subtle server-side authentication vulnerability** where the application returns almost identical error messages for invalid logins.

Although the responses look the same at first glance, **small differences in server responses** can still leak information. In this case, a minor formatting difference allows an attacker to enumerate valid usernames and then brute-force passwords.

---

## Goal of the Lab
- Enumerate a valid username by identifying subtle response differences
- Brute-force the password for that user
- Log in and access the account page

---

## Tools Used
- Burp Suite
  - Proxy
  - Intruder (Sniper attack)
  - Grep - Extract
- Provided username wordlist
- Provided password wordlist

---

## How I Solved It

### 1. Intercepting the Login Request
With Burp running, I submitted an invalid username and password.

Using **Proxy → HTTP history**, I located the `POST /login` request and sent it to **Burp Intruder**.  
The `username` parameter was automatically marked as a payload position.

---

### 2. Enumerating a Valid Username Using Subtle Differences
In Intruder:
- Attack type: **Sniper**
- Payload type: **Simple list**
- Payload: candidate usernames

To detect subtle differences, I configured **Grep - Extract** in the **Settings** tab.

I extracted the error message:
```

Invalid username or password.

```

After running the attack, a new column appeared showing the extracted error message.

When sorting the results, I noticed:
- Most responses were identical
- One response was **slightly different**

On closer inspection, that response contained a **trailing space instead of a full stop**, indicating that the server processed the username differently.

This confirmed a **valid username**, which I noted down.

---

### 3. Brute-Forcing the Password
Next, I fixed the identified username and placed the payload position on the password parameter:

```

username=identified-user&password=§invalid-password§

```

I replaced the payload list with the candidate passwords and started the attack.

After reviewing the results:
- Most responses returned **HTTP 200**
- One response returned **HTTP 302**

The **302 redirect** indicated a successful login.  
I noted the corresponding password.

---

### 4. Logging In
Using the identified username and password, I logged in through the normal login page and accessed the account page, completing the lab.

---

## Why This Is a Server-Side Issue
The vulnerability exists because the backend:

- Processes valid and invalid usernames differently
- Returns slightly different response content
- Does not normalize error messages

Even extremely small server-side differences (such as whitespace or punctuation) can be abused.

---

## Key Takeaways
- Authentication responses must be completely consistent
- Small formatting differences can leak sensitive information
- Username enumeration enables efficient brute-force attacks
- Subtle server-side flaws can be just as dangerous as obvious ones

---

## Impact
- Valid usernames can be identified
- Targeted password brute-force becomes possible
- Increases the risk of account compromise

---

## Why I’m Documenting This
I’m documenting this lab as:
- A personal learning record
- Proof of attention to detail in security testing
- Experience with real-world server-side authentication flaws
- Preparation for interviews and security assessments


 
