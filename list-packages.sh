#!/bin/sh
echo "/corporate2/devel-x86_64 için cd icerigi hazirlaniyor."
echo "#" > workQueue
echo "" > olmayanlar.txt
echo "" > liste.txt
svn co http://svn.pardus.org.tr/uludag/trunk/distribution/Corporate2/project-files
cat project-files/corporate2.xml | grep SelectedPackage | cut  -d\> -f2 | cut -d\< -f1 > liste.txt
cat project-files/corporate2.xml | grep SelectedComponent | cut  -d\> -f2 | cut -d\< -f1 > liste2.txt
sed 's/\./\//g' liste2.txt > liste3.txt
exec<"liste.txt"
while read line
do
    a=$( find /corporate2/devel-x86_64/ -name pspec.xml | grep /$line/pspec.xml)
    echo $a
    if [ "$a" == "" ]; then
        echo $line >> olmayanlar.txt
    else
        echo $a >> workQueue
    fi
done
exec<"liste3.txt"
while read line
do
    find /corporate2/devel-x86_64/$line -name pspec.xml >> workQueue
done
find /corporate2/devel-x86_64/system/devel -name pspec.xml >> workQueue
python get_dep.py
exec<"dep.txt"
while read line
do
    a=$( find /corporate2/devel-x86_64/ -name pspec.xml | grep /$line/pspec.xml)
    echo $a
    if [ "$a" == "" ]; then
        echo $line >> olmayanlar.txt
    else
        echo $a >> workQueue
    fi
done
rm  liste.txt dep.txt liste3.txt liste2.txt
echo "bitti"