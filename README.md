# gappw

gappw.sh [ -n -c -h ] FILENAME

Usage: Find band gaps from pw.x(Quantum Espresso) output file.

Band gaps for each relax step are generated.

For semiconductors and insulators only, should include empty bands, use 
```occupations='smearing'``` or increase ```nbnd```.

run as:
```
 $./gappw.sh pw.out
-n : noncollinear format
-c : collinear format
-h : show this message
```

N.B. spin-polarized not implement

Sample output:
```
reading relax.out
number of k-piont  = 48
number of band =  31
number of atomic type =  2
number of valence electron =  20.000000 6.000000
number of atoms =  4
atomic species =  Zn O
vbm =  26
written to VBMCBM
vbm_k= 1 cbm_k= 1
vbm= 10.1849 cbm= 11.0124 Eg= 0.8275
vbm_k= 1 cbm_k= 1
vbm= 10.1827 cbm= 11.0125 Eg= 0.8298
vbm_k= 1 cbm_k= 1
vbm= 10.1797 cbm= 11.0142 Eg= 0.8345

```
