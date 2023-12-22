
>[!info]
>This note is still in development.


```cs
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public class Example
{
	// Using Esoteric Windows API Calls
	[DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
    static extern IntPtr VirtualAllocExNuma(IntPtr hprocess, IntPtr lpAddress, uint dwSize, UInt32 flAllocationType, UInt32 flProtect, UInt32 nndPreffered);
    
    [DllImport("kernel32.dll")]
    static extern IntPtr GetCurrentProcess();


	public static void Main()
	{
		// Rudimentary AV Heuristics Bypass by calling an Uncommon API
		IntPtr mem = VirtualAllocExNuma(GetCurrentProcess(), IntPtr.Zero, 0x1000, 0x3000, 0x4, 0);
        if (mem == null)
        {
            return;
        }

		// The rest of your code here...
	}
}
```