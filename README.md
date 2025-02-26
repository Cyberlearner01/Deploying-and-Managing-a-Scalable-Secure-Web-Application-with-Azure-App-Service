#### **Introduction**

In this project, I will deploy and manage a web application using Azure App Service, incorporating advanced features such as custom domains, SSL/TLS, monitoring, and disaster recovery. This project demonstrates my ability to go beyond basic deployment and showcase skills in scalability, security, and automation.

* * *

### **Lab Scenario**

Hi, I’m Johnson, an aspiring Azure DevOps engineer passionate about designing scalable, secure, and reliable cloud solutions. For this project, I’m building a production-ready web application using Azure App Service to showcase my skills in deploying and managing cloud-based infrastructure.
When launching a new website or migrating an existing one from outdated on-premises servers, the process can be complex. Traditional setups require dedicated hardware, server-level operating systems, and a web-hosting stack. Beyond the initial setup, ongoing maintenance is necessary, and scaling up to handle increased traffic often means investing in additional hardware.
By leveraging Azure App Service, I’ve streamlined the deployment and management of the web application, eliminating the need for physical servers. This project demonstrates my ability to implement DevOps best practices, including the use of deployment slots for smooth updates and rollbacks, ensuring minimal downtime during releases.
I’ve also configured custom domains and SSL/TLS certificates to secure the application, implemented autoscaling to handle traffic spikes, and set up monitoring to track performance and health. To ensure data safety and high availability, I’ve integrated backup and disaster recovery solutions. This project goes beyond following instructions; it’s about applying my expertise to solve real-world challenges and deliver a solution that’s ready for the demands of a live, production environment.

* * *

### **Objectives**

In this lab, I will:
1.  Create an Azure Web App with custom configurations.
    
2.  Create a Staging Deployment Slot for testing.
    
3.  Deploy Code to Staging and validate functionality.
    
4.  Swap Staging and Production Slots for zero-downtime deployments.
    
5.  Configure Autoscaling to handle traffic spikes.
    
6.  Add a Custom Domain and SSL/TLS for secure access.
    
7.  Set Up Monitoring and Alerts using Azure Monitor.
    
8.  Implement Disaster Recovery with backup and restore.
    
9.  Optimize Costs using Azure Pricing Calculator and recommendations.
    

* * *

### **Architecture Diagram**

<img width="1021" alt="Screenshot 2025-02-26 at 12 52 57 PM" src="https://github.com/user-attachments/assets/03e894e7-39ae-4875-88c0-443f396436fa" />


* * *

### **Instructions**

#### **Exercise 1: Create and Configure the Azure Web App**

**Task 1: Create an Azure Web App**
*   Sign in to the Azure portal.
    
*   Create a new **App Service** with the following settings:
    *   **Runtime Stack**: .NET 6 (LTS) or Node.js (depending on your preference).
        
    *   **Operating System**: Linux (for cost efficiency).
        
    *   **App Service Plan**: Premium V3 P1V3 (for better performance).
        
    *   **Region**: Choose a region closest to your users.
        
*   Enable **Always On** and **HTTPS Only** for better reliability and security.
    
**Task 2: Configure Production Deployment Settings**
*   Set up **Azure Repos** as the deployment source.
    
*   Deploy the initial version of the web app to the production slot.
    

* * *

#### **Exercise 2: Implement Staging and Zero-Downtime Deployments**

**Task 3: Create a Staging Deployment Slot**
*   Add a **staging slot** to your web app.
    
*   Configure the staging slot with the same settings as production but with a different environment configuration (e.g., connection strings for a test database).
    
**Task 4: Deploy Code to Staging**
*   Push code to the staging slot.
    
*   Validate the deployment by accessing the staging URL.
    
**Task 5: Swap Staging and Production Slots**
*   Use the **Swap** feature to promote the staging slot to production.
    
*   Verify that the production site is updated without downtime.
    

* * *

#### **Exercise 3: Enhance Security and Scalability**

**Task 6: Add a Custom Domain and SSL/TLS**
*   Purchase a custom domain (e.g., from GoDaddy or Azure Domain Services).
    
*   Bind the custom domain to your web app.
    
*   Configure **SSL/TLS** using a free certificate from Let's Encrypt or Azure App Service Managed Certificates.
    
**Task 7: Configure Autoscaling**
*   Set up **rule-based autoscaling** based on CPU usage or request count.
    
*   Test autoscaling by simulating traffic using powershell command**.
    

* * *

#### **Exercise 4: Monitor and Optimize**

**Task 8: Set Up Monitoring and Alerts**
*   Enable **Azure Monitor** for your web app.
    
*   Create alerts for high CPU usage, memory usage, and failed requests.
    
*   Use **Application Insights** to track performance and diagnose issues.
    
**Task 9: Implement Disaster Recovery**
*   Configure **automated backups** for your web app.
    
*   Test the backup by restoring it to a new web app.
    
**Task 10: Optimize Costs**
*   Use the **Azure Pricing Calculator** to estimate costs.
    
*   Apply **Azure Advisor recommendations** to reduce costs (e.g., resizing the App Service Plan).
    



* * *

### **Review**

In this lab, I have:
*   Created and configured an Azure Web App with advanced settings.
    
*   Used staging slots for zero-downtime deployments.
    
*   Enhanced security with custom domains and SSL/TLS.
    
*   Set up monitoring, alerts, and disaster recovery.
    
*   Optimized costs and demonstrated scalability.
