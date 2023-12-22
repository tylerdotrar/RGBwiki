
## Terminology
---

- **ICS (Industrial Control System)** is a broad term that encompasses various types of control systems used in industrial and critical infrastructure settings. These systems are designed to control and monitor physical processes, machinery, and devices. ICS includes different components, such as PLCs, RTUs, and HMIs.

- **SCADA (Supervisory Control and Data Acquisition)** is a subset of ICS. It typically operates at a higher level and provides centralized control and monitoring capabilities. SCADA systems collect data from sensors and control devices located in the field, such as PLCs and RTUs. They use network communication to transmit this data to a central location. SCADA software visualizes the data and allows operators to control processes remotely. SCADA systems often include HMI components.

- **PLC (Programmable Logic Controller)** is a ruggedized industrial computer designed to control manufacturing processes and machines. It operates by receiving input data from sensors and switches, executing a control program based on user-defined logic, and then providing output commands to control machinery or processes. PLCs are commonly used in manufacturing and industrial settings for tasks like automation, data collection, and machine control.

- **HMI (Human Machine Interface)** is a software or hardware interface that allows human operators to interact with machines, systems, and processes. It typically provides a visual representation of the process being controlled, often through graphical elements like displays, charts, and alarms. HMIs enable operators to monitor and control processes, set parameters, and receive feedback, making them essential tools for supervising industrial and manufacturing operations.


## ICS SCADA Network Introduction
---
- **ICS SCADA environments...**
	1. are simple networks and have low complexity.
		- Statically set IPs.
		- Rarely contain services (e.g., DHCP, DNS).
		- Reused passwords.
		- Not frequently updated.
	 1. require high availability.
		- No Intrusion Prevention System (IPS).
		- Can't do mass network scans (risk breaking the network).
	 2. have a simple exploitation checklist:
		- Determine what protocol is being used for communication (e.g., S7COMM, CIP).
		- Find the target PLC (e.g., check ARP table, discovery via broadcast).
		- If you can ping it, you can pwn it.