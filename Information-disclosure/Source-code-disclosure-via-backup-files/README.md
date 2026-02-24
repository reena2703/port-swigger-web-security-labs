# Information Disclosure – Source Code Disclosure via Backup Files

(**Web Security Academy**)

This lab demonstrates how **exposed backup files** can lead to **full source code disclosure**, ultimately leaking **hard-coded credentials** that compromise backend systems.

---

## Lab: Source Code Disclosure via Backup Files

**Category:** Information disclosure
**Context:** Exploiting
**Level:** Apprentice
**Status:** Solved

---

## What This Lab Is About

The application unintentionally exposes **backup files** containing sensitive source code. These files reside in a hidden directory that is either:

* Disclosed via `robots.txt`, or
* Discoverable through content enumeration

The goal is to **locate the leaked source code** and extract the **hard-coded database password**.

---

## Initial Recon

1. Browsed the application normally
2. Checked for common information disclosure points
3. Navigated to:

```text
/robots.txt
```

---

## Discovering the Backup Directory

The `robots.txt` file revealed a hidden directory:

```text
Disallow: /backup
```

This immediately indicates a potential **information disclosure risk**, as sensitive files are often mistakenly stored in backup locations.

---

## Enumerating Backup Files

1. Browsed directly to:

```text
/backup
```

2. Identified a backup source file:

```text
ProductTemplate.java.bak
```

Alternatively, the same directory could be discovered via **Burp Suite**:

* Target → Site Map
* Right-click the lab domain
* Engagement tools → Discover content

---

## Source Code Disclosure

Accessing the file:

```text
/backup/ProductTemplate.java.bak
```

revealed **full Java source code**, including database connection logic.

Within the code, a **PostgreSQL connection builder** contained a **hard-coded password**.

Example (simplified):

```java
connectionBuilder
    .setUsername("postgres")
    .setPassword("********");
```

This password is the **solution to the lab**.

---

## Submitting the Solution

1. Returned to the lab interface
2. Clicked **Submit solution**
3. Entered the extracted database password

 

---

## Steps I Followed

1. Checked `robots.txt` for hidden paths
2. Identified the `/backup` directory
3. Browsed the backup directory
4. Located a `.bak` source file
5. Reviewed leaked Java source code
6. Extracted the hard-coded database password
7. Submitted the solution

---

## Why This Is Dangerous

Exposed backup files can leak:

* Full application source code
* Hard-coded credentials
* Database connection strings
* API keys
* Internal logic and architecture

With database credentials, an attacker may:

* Access sensitive user data
* Modify or delete records
* Pivot further into internal systems
* Achieve full backend compromise

---

## Defensive Takeaways

To prevent this vulnerability:

* Never expose backup files in web directories
* Restrict access to non-production files
* Remove sensitive entries from `robots.txt`
* Avoid hard-coding credentials
* Use environment variables or secrets managers
* Regularly scan for exposed files and directories

---

## Key Lesson

> **Anything accessible over HTTP must be treated as public.**

Backup files are not harmless — they are often **more dangerous than the live application itself**.

 
