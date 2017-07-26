# This should bash

# I use google photos to snap pix of my receipts.  Then I download them all to my laptop to a dedicated folder

# prereqs:  
# brew install imagemagick
# pip3 install img2pdf

# resize all jpgs 300kb size in $PWD
for x  in `find . -size +301k -name '*.jpg' -print `; do convert $x -define jpeg:extent=300kb ${x}.jpg; done

# convert all jpgs to a single PDF
img2pdf --output ../redhat-jmaltin-expense-report-1-imgs.pdf *.jpg

# join all PDFs into one PDF
"/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" -o ../redhat-jmaltin-expense-report-1.pdf ../redhat-jmaltin-expense-report-1-imgs.pdf *.pdf

# email out redhat-jmaltin-expense-report-1.pdf 
