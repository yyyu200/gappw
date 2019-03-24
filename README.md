# gappw

gappw.sh [ -n -c -h ] FILENAME

Usage: Find band gap from PWscf output file.

Band gap for each relax step is generated.

For semiconductor and insulator only.

run as:
```
 $./gappw.sh pw.out
-n : noncollinear format
-c : collinear format
-h : show this message
```

N.B. spin-polarized not implement
