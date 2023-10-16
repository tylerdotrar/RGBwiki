
### Overview
--- 
Java Remote Method Invocation (Java RMI) enables the programmer to create distributed Java technology-based to Java technology-based applications, in which the methods of remote Java objects can be invoked from other Java virtual machines, possibly on different hosts.

Realistically, this technology is a huge can of worms that I don't know much about.  However, that's where [Remote Method Guesser](https://github.com/qtc-de/remote-method-guesser) comes into play:

>[!info]
> _remote-method-guesser_ (_rmg_) is a _Java RMI_ vulnerability scanner and can be used to identify and verify common security vulnerabilities on _Java RMI_ endpoints.


### Remote-Method-Guesser (RMG) Installation
---
RMG was originally built off of Java 8 (which is a surprising hassle to install on modern Kali Linux), and subsequently does not work with modern versions of Java.

**RMG v4.3.1:**
- To install, we need to download an archived OpenJDK 8 binary to specify when running ``rmg.jar``. 

```shell
# Download RMG & Java 8 (modern Java doesn't work with RMG)
wget https://github.com/qtc-de/remote-method-guesser/releases/download/v4.3.1/rmg-4.3.1-jar-with-dependencies.jar
wget https://builds.openlogic.com/downloadJDK/openlogic-openjdk-jre/8u352-b08/openlogic-openjdk-jre-8u352-b08-linux-x64.tar.gz

# Extract & Rename
tar -xzvf openlogic-openjdk-jre-8u352-b08-linux-x64.tar.gz
rm -f openlogic-openjdk-jre-8u352-b08-linux-x64.tar.gz
mv openlogic-openjdk-jre-8u352-b08-linux-x64 openjdk-jre-8
mv rmg-4.3.1-jar-with-dependencies.jar rmg.jar
```

>[!info]
>	Supposedly as of RMG v4.4.0, it is now compatible with Java16+.  I have not validated this, but it's noteworthy.


### General Usage:
---
Below is very high level usage syntax (specifically for the v4.3.1 installed above).
- For more verbose and granular usage, reference [the project's GitHub page](https://github.com/qtc-de/remote-method-guesser).

```shell
# v4.3.1: Scan and Enumerate targets using the OpenJDK 8 binary
./openjdk-jre-8/bin/java -jar rmg.jar scan <target>
./openjdk-jre-8/bin/java -jar rmg.jar enum <target> <port>
```

![[Pasted image 20230105193621.png]]
