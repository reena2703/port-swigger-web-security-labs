# Discovering Vulnerabilities with Targeted Scanning

## Lab Source
PortSwigger Web Security Academy  
Essential Skills

## Overview
This lab focuses on using **targeted scanning** in Burp Suite to quickly identify potential vulnerabilities instead of scanning the entire application. It helps understand how selective scanning saves time and produces more meaningful results.

## What I Did
- Set up Burp Suite as a proxy and explored the application normally.
- Identified important requests and parameters that accept user input.
- Ran targeted scans on specific requests rather than performing a full scan.
- Reviewed the scan results to understand which issues need manual verification.

## Key Observations
- Targeted scanning is faster and more efficient than full application scans.
- It helps reduce unnecessary noise and false positives.
- Scanner results are helpful but should always be verified manually.

## Result
I was able to quickly identify potential security issues using focused scanning techniques and understood how automated tools assist in the early stages of vulnerability discovery.

## Tools Used
- Burp Suite Community Edition
- Web Browser

## What I Learned
- How to use Burp Suite’s targeted scanning effectively.
- Why focused scanning is preferred in real-world security testing.
- The importance of combining automated scanning with manual analysis.
