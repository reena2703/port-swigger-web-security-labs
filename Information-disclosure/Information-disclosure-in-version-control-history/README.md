# Information Disclosure – Version Control History Exposure

(**Web Security Academy**)

This lab demonstrates how **exposed version control metadata** can leak **previously removed secrets**, leading to **administrator account compromise** and **full privilege escalation**.

---

## Lab: Information Disclosure in Version Control History

**Category:** Information disclosure
**Context:** Exploiting
**Level:** Practitioner
**Status:** Solved

---

## What This Lab Is About

The application accidentally exposes its **Git version control directory** (`.git`) to the public.

Although sensitive data was removed from the live source code, it remains accessible in the **Git commit history**, allowing attackers to:

* Download the full repository metadata
* Inspect commit diffs
* Recover previously deleted secrets
* Compromise privileged accounts

The objective is to:

1. Recover the administrator password from Git history
2. Log in as the administrator
3. Delete the user **carlos**

---

## Initial Discovery

Browsing directly to:

```text
/.git/
```

Revealed:

* A publicly accessible Git repository
* Full version control metadata exposed to unauthenticated users

This immediately indicates a **critical information disclosure** issue.

---

## Downloading the Git Repository

To analyze the repository locally, the entire `.git` directory was downloaded.

### Linux / macOS

```bash
wget -r https://YOUR-LAB-ID.web-security-academy.net/.git/
```

### Windows

* Use a UNIX-like environment (e.g. WSL, Cygwin, Git Bash)
* Or manually download the files via a browser

Once downloaded, the directory structure resembled a confirmation of a valid Git repository:

```
.git/
 ├── HEAD
 ├── config
 ├── objects/
 ├── refs/
 └── logs/
```

---

## Inspecting the Commit History

Using Git locally, the repository history was explored:

```bash
git log
```

A particularly interesting commit was found:

```text
Remove admin password from config
```

This commit message strongly suggests that **sensitive data previously existed** in the repository.

---

## Recovering the Admin Password

The diff for this commit was inspected:

```bash
git show <commit-hash>
```

### Key Observation

* The file `admin.conf` was modified
* A **hard-coded administrator password** was removed
* The password was replaced with an environment variable:

```text
ADMIN_PASSWORD
```

However:

> **Git diffs preserve removed content**

The original admin password was still visible in the commit diff.

---

## Exploitation

### Step 1: Log in as Administrator

Using the recovered credentials:

* Username: `administrator`
* Password: *(leaked from Git history)*

Login was successful.

---

### Step 2: Privilege Abuse

With admin access:

* Navigated to the admin panel
* Deleted the user **carlos**

The lab was immediately marked as **solved**.

---

## Steps I Followed

1. Browsed to `/.git/`
2. Confirmed public access to Git metadata
3. Downloaded the full `.git` directory
4. Inspected commit history locally
5. Identified a commit removing the admin password
6. Extracted the password from the diff
7. Logged in as the administrator
8. Deleted user `carlos`
9. Completed the lab

---

## Why This Worked

* Version control metadata was publicly accessible
* Secrets removed from code were still present in Git history
* No access controls protected the `.git` directory
* The administrator password was hard-coded at some point

This violates multiple secure development practices.

---

## Impact

An attacker can:

* Recover sensitive credentials
* Gain administrator access
* Perform destructive actions
* Delete users
* Fully compromise the application

This is a **high-severity information disclosure vulnerability**.

---

## Key Lessons Learned

* Removing secrets from code does **not** remove them from history
* `.git` directories must never be publicly accessible
* Version control leaks often lead to full compromise
* Secrets should never be hard-coded
* Attackers actively check for exposed VCS directories

---

## Defensive Takeaways

To prevent this issue:

* Block access to `.git`, `.svn`, `.hg`, and backup files
* Rotate credentials immediately if leaked
* Use environment variables or secret managers
* Scan repositories for secrets before deployment
* Enforce proper web server access controls

---

## Final Summary

* Public Git repository exposed
* Commit history leaked removed credentials
* Admin password recovered from diff
* Administrator account compromised
* User deleted successfully

 
