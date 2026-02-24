# Information Disclosure – Error Message Leakage

(**Web Security Academy**)

This lab demonstrates how **verbose error messages** can unintentionally leak **sensitive internal information**, such as the exact version of a backend framework, which can later be chained with known vulnerabilities.

---

## Lab: Information Disclosure in Error Messages

**Category:** Information disclosure
**Context:** Exploiting
**Level:** Apprentice
**Status:** Solved

---

## What This Lab Is About

The application exposes **detailed stack traces** when unexpected input is supplied. These error messages reveal:

* Backend implementation details
* Third-party framework usage
* **Exact framework version numbers**

The goal is to **trigger an error**, identify the framework version, and submit it as the solution.

---

## Initial Recon

1. Enabled **Burp Suite**
2. Browsed to a product page
3. Observed the following request in **Proxy → HTTP history**:

```http id="g1z8c4"
GET /product?productId=1
```

This indicates that product pages rely on a `productId` query parameter.

---

## Triggering the Vulnerability

To test how the server handles unexpected input:

1. Sent the request to **Burp Repeater**
2. Changed the parameter type from an integer to a string:

```http id="d2m9xk"
GET /product?productId="example"
```

---

## Resulting Behavior

* The server throws an **unhandled exception**
* A **full stack trace** is returned in the HTTP response
* The error message reveals internal implementation details

---

## Information Disclosure Identified

Inside the stack trace, the following framework and version were exposed:

```
Apache Struts 2 2.3.31
```

This confirms:

* The application is using **Apache Struts**
* The version is **2.3.31**, which is known to be vulnerable to multiple historical exploits

---

## Submitting the Solution

1. Returned to the lab page
2. Clicked **Submit solution**
3. Entered:

```
2 2.3.31
```
 

## Steps I Followed

1. Intercepted traffic using Burp Proxy
2. Identified the `productId` parameter
3. Sent request to Burp Repeater
4. Supplied an invalid data type
5. Triggered a server-side exception
6. Reviewed the verbose error message
7. Extracted framework name and version
8. Submitted the disclosed version

---

## Why This Is a Problem

Verbose error messages can:

* Reveal backend technologies
* Disclose exact software versions
* Enable attackers to:

  * Search for known CVEs
  * Launch targeted exploits
  * Chain vulnerabilities effectively

This is a classic **low-effort, high-value information disclosure** issue.

---

## Defensive Takeaways

To prevent this type of vulnerability:

* Disable stack traces in production
* Use generic error messages for users
* Log detailed errors server-side only
* Implement global exception handling
* Regularly patch third-party frameworks

---

## Key Lesson

> Even when no direct exploit is present, **information disclosure dramatically lowers the barrier to attack**.

Error messages should help developers — **not attackers**.

 
