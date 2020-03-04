# gappw

```
gappw.sh [ -n -c -h ] FILENAME
-n : noncollinear format
-c : collinear format
-h : show this message
```

Usage: Find band gaps from pw.x(Quantum Espresso) output file.

Band gaps for each relax step are generated.

For semiconductors and insulators only, should include empty bands, use 
```occupations='smearing'``` or increase ```nbnd```.

run as:
```
 $./gappw.sh pw.out

```

N.B. set verbosity='high' in scf calculation for No. of k-points > 100; spin-polarized not implement; more accurate gap should get more digits from outdir. 

Sample output:
```
reading relax.out
number of k-piont  = 48
number of band =  31
number of atomic type =  2
number of valence electron =  20.00 6.00
number of atoms =  4
atomic species =  Zn O
valence band= 26 <= total band= 31
written to /tmp/VBMCBM_26727
vbm_k= 1 cbm_k= 1
E(vbm)= 10.1849 E(cbm)= 11.0124 Eg= 0.8275
vbm_k= 1 cbm_k= 1
E(vbm)= 10.1827 E(cbm)= 11.0125 Eg= 0.8298
vbm_k= 1 cbm_k= 1
E(vbm)= 10.1797 E(cbm)= 11.0142 Eg= 0.8345
vbm_k= 1 cbm_k= 1
E(vbm)= 10.1852 E(cbm)= 11.0190 Eg= 0.8338
vbm_k= 1 cbm_k= 1
E(vbm)= 10.1839 E(cbm)= 11.0177 Eg= 0.8338
```


##############################################################################
# This program could be rewritten in C or Golang for faster performance.
# Or it could be rewritten in Python or another higher level language
# for more modularity.
# However, I've insisted on shell here for transparency!
#                                                                     - Y.Z
##############################################################################


