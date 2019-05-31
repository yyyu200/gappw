#!/bin/bash
function HELP {
    echo -e "gappw.sh [ -n -c -h ] FILENAME";
    echo -e "Usage: Find band gap from PWscf output file\nFor semiconductor and insulator only\nrun as\n $./gappw.sh pw.out";
    echo "-n : noncollinear format";
    echo "-c : collinear format";
    echo "-h : show this message";
    echo "N.B. spin-polarized not implement"
    exit 1 ;
}

if [[ -z $1 ]] || [[ $1 = "--help" ]];then 
    HELP
    exit 1
fi

while getopts "nch" arg
do
    case $arg in
        #f)
        #    file_in=`echo "$OPTARG"`;
        #    echo "reading $file_in";;
        n)
            echo "noncollinear";
            flag_noncol=1;;
        c)
            echo "collinear";
            flag_noncol=0;;
        h)
            HELP;;
        ?)
            echo -e "\nERROR : Option -$OPTARG not allowed.\n"
            HELP;;
    esac
done

shift $(($OPTIND -1))
file_in=$1
tmp_file=/tmp/VBMCBM_$RANDOM
while [[ -e $tmp_file ]];do
    tmp_file=/tmp/VBMCBM_$RANDOM
done

if [ $# -eq 1 ];then
    if [ -e $1 ];then
        file_in=$1
        echo "reading $file_in"
    else
        echo "file $1 can not open."
        HELP
        exit 1
    fi
fi

NKPT=`grep "number of k points=" $file_in|head -1|awk '{print $5}'`
if [ -z $NKPT ];then 
    echo -e "No k-point found"
    exit 1
fi

NBD=`grep "number of Kohn-Sham states=" $file_in|head -1|awk '{print $5}'`

NTYP=`grep "number of atomic types    =" $file_in|head -1|awk '{print $6}'`
#NTYP=$(awk '/number of atomic types    =/{print $6}' $file_in|head -1)

IZVAL=$(awk 'BEGIN{c='"$NTYP"';flag=0}/atomic species   valence/{flag++;if(flag==1)for(i=0;i<c;i++){getline;print $2}}' $file_in)
ELEM=$(awk 'BEGIN{c='"$NTYP"';flag=0}/atomic species   valence/{flag++;if(flag==1)for(i=0;i<c;i++){getline;print $1}}' $file_in)

NAT=`grep "number of atoms/cell      =" $file_in|head -1|awk '{print $5}'`

echo "number of k-piont  = "$NKPT
echo "number of band = " $NBD
echo "number of atomic type = " $NTYP
echo "number of valence electron = " ${IZVAL[@]}
echo "number of atoms = " $NAT
echo "atomic species = " ${ELEM[@]}

NVBM=`awk -v var1="${ELEM[*]}" -v var2="${IZVAL[*]}" -v flag_noncol="${flag_noncol}" 'BEGIN{
    nat='"$NAT"'
    lens=split(var1,elem," ")
    split(var2,izval," ")
    #print lens" "elem[1]" "elem[2]
    for(i=1;i<=lens;i++){
        ielem[i]=0
    }
    nvbm=0
    count=0
}
/Cartesian axes/{
    count++
    getline
    getline
    for(i=1;i<=nat;i++){
        getline
        for(j=1;j<=lens;j++)
            if($2==elem[j]&&count==1 )
            {
                ielem[j]++
            }
    }
}
END{
    for(i=1;i<=lens;i++){
        #print ielem[i]
        nvbm+=izval[i]*ielem[i]
    }
    if (flag_noncol==1)
        print nvbm
    else
        print nvbm/2
}' $file_in`

#echo "number of each species = " ${IELEM[@]}


if [[ $NVBM -ge $NBD ]];then
    echo "NVBM= $NVBM, NBND= $NBD"
    echo "ERROR: vbm >= nbnd"
    exit 0
else
    echo "valence band = $NVBM"
    echo "total band = $NBD"
fi

awk 'BEGIN{
    c=0;
    i_scf=0;
    nkpt='"$NKPT"'
    nbd='"$NBD"'
}
/ k =/{
    c++
    if(c%nkpt==0)
        i_scf++
    getline
    
    if(int(nbd/8.0)==nbd/8.0)
        lineband=nbd/8.0
    else
        lineband=int(nbd/8.0)+1
    for(i=1;i<=lineband;i++)
    {
       getline
       for(j=1;j<=8;j++)
            bd[c,8*(i-1)+j]=$j
    }
    getline
    for(j=1;j<=nbd-lineband*8;j++)
    {
       bd[c,8*lineband+j]=$j 
    }
}
END{
    num_scf=i_scf
    print i_scf
    for(i=1;i<=c;i++)
    {
        print bd[i,'"$NVBM"'] " " bd[i,'"$NVBM"'+1] " " bd[i,'"$NVBM"'+1]-bd[i,'"$NVBM"']
        if(i%nkpt==0) print ""
    }
}
' $file_in > $tmp_file

echo "written to $tmp_file"

awk 'BEGIN{
    getline
    i_scf=$1
    nkpt='"$NKPT"'
    for(i=1;i<=i_scf;i++)
    {
        vmax=-999999
        vi=0
        cmin=999999
        ci=0
        for(j=1;j<=nkpt;j++)
        {
            getline
            vb[j]=$1
            cb[j]=$2
            if(vb[j]>vmax){
                vmax=vb[j]
                vi=j
            }
            if(cb[j]<cmin){
                cmin=cb[j]
                ci=j
            }
        }
        getline
        print "vbm_k= " vi  " cbm_k= " ci
        print "E(vbm)= " vmax " E(cbm)= " cmin " Eg= " cmin-vmax
    }
}
' $tmp_file

