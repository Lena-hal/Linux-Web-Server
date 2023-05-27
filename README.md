# Linux Web Server - technical documentation

1. Introduction
2. Requirements Analysis
3. Architecture and Infrastructure
4. Solution Overview
5. Customer's Workflow

## Introduction

This technical documentation describes the implementation of the Linux Web Hosting Server project (more about ths assigment can be found [here](https://www.eduxo.cz/v/projekty/2022-2023/linux-webhosting-server)). The goal of this project is to create a robust and secure web hosting server that provides web hosting services to customers. This documentation provides a detailed overview of the server's implementation and configuration, including the technologies and procedures used.

## Requirements Analysis

### Secure connection with SSH
- users will be forced to connect with certificate and accesing with a password will be disabled
- to ensure the protection we should add a paraphrase to those keys, i chose to have a random string of 16 letters as the paraphrase.
### Server resilience and data backup
- The server will be designed to be resilient to errors and data loss. Data backup and recovery mechanisms will be implemented as part of the solution.
### Scalability for customers domains
- The server will be designed to easily add new domains on demand
- every subdomain will have it's own TLS certificate
### Custom web server or content management system for customers
- I chose the option to create a custom web server with a SFTP access to all customers because it adds bigger customisability for hosted websites

## Architecture and Infrastructure
### OS
- This server runs on Ubuntu 22.04 because of its stability, security and wide support
### Registration and management of the ssibrno.cz domain
- The domain ssibrno.cz has been registered for this project. Registration and domain management are handled by the teacher
### Web server
- Web server used in this project is [Nginx](https://www.nginx.com/)
### Server security through certificate-based authentication
- Server can be accesed only by customers or authorized individuals such as a server administrator
### Reverse proxy
- [Nginx](https://www.nginx.com/) was chosen to work as a reverse proxy for the subdomain management because of the easy setup

## Solution Overview

The solution involves creating a separate account on the server for each customer, which allows them to access the server via SSH and SFTP connections. Each customer's account includes a linked folder located at /var/www/html/, where Nginx retrieves the files for their respective websites.

### Account and Domain Management

When creating an account for a customer, a new server block is added for their domain. The root folder for the domain is set to the folder associated with the customer's account. This ensures that the requested domain points to the correct location and avoids 404 errors.

To handle situations where a requested site does not exist, a feature has been implemented to redirect users to a default `index.html` file. This helps prevent unwanted errors on customers' websites.

### Automation Script

To ensure easy scalability and simplify the setup process, an automation script has been developed. By running the script with the customer's name and domain as input, the script checks if the customer's account already exists. If the account exists, the script adds the domain to the existing account. If the account does not exist, the script creates a new account and sets it up with all the necessary components, including SSH keys and linked folders.

The script also generates a randomly generated security passphrase for the SSH keys to enhance security.

### Conclusion

The implemented solution successfully addresses the requirements of the Linux Web Hosting Server project. By creating separate accounts for customers, setting up linked folders, and automating the domain and account management process, the solution provides a scalable and secure web hosting environment.

## Customer's Workflow

### Registration and Domain Request
The customer initiates the workflow by visiting the registration page and creating a personalized account. This account creation process entails providing requisite details and completing the necessary registration steps.

Subsequently, the customer submits a domain request on the registration page. Upon submitting the domain request, an automated script promptly initiates the process of provisioning an account with the requested domain. The script diligently attempts to create the account while ensuring that it does not already exist or that the requested domain is not already assigned to another user.

### Account Creation and Credentials

If the automated script successfully executes the account creation process, the customer is granted access to their newly created account. At this juncture, the customer receives their private SSH key and the corresponding key paraphrase. These crucial credentials bestow upon them the capability to securely connect to the server via SSH and SFTP protocols.

### Website Development and Management

With the acquired SSH key and key paraphrase, the customer gains the ability to establish a secure connection to the web hosting server. Leveraging this connection, the customer can effortlessly create and manage their website on the designated domain.

Additionally, customers have the option to request their own domain. In such cases, the customer is responsible for configuring their DNS server to include the IP address of the web server. This crucial step establishes the necessary linkage between the requested domain and the customer's web page, enabling seamless accessibility for end-users.

### Conclusion

The delineated customer workflow elegantly encapsulates the seamless progression from registration to domain request, account creation, and subsequent website development. The automated provisioning script ensures an efficient and hassle-free account creation process. By providing customers with their unique SSH key and key paraphrase, the system enables secure and authenticated access to the web hosting server. Furthermore, customers are afforded the flexibility to request their own domain and subsequently manage their web presence through the DNS configuration process.
