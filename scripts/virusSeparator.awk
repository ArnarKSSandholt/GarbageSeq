#!/bin/awk -f
{
    # Check if there is an output dir given, if not give this generic one as such
    if (length(output_dir) == 0){
        output_dir = "../analyses/"
    }
    if($5 == "Caudovirales") {
        print $0 > output_dir"caudovirales.annot"
    } else if ($5 == "Herpesvirales") {
        print $0 > output_dir"herpesvirales.annot"
    } else if ($5 == "Myoviridae") {
        print $0 > output_dir"myoviridae.annot"   
    } else if ($5 == "Podoviridae") {
        print $0 > output_dir"podoviridae.annot"    
    } else if ($5 == "Siphoviridae") {
        print $0 > output_dir"siphoviridae.annot"    
    } else if ($5 == "Tectiviridae") {
        print $0 > output_dir"tectiviridae.annot"    
    } else if ($5 == "dsDNA") {
        print $0 > output_dir"dsDNA.annot"    
    } else if ($5 == "ssDNA") {
        print $0 > output_dir"ssDNA.annot"    
    } else if ($5 == "Viruses") {
        print $0 > output_dir"viruses.annot"    
    } else {
        print "Something in the field 5 is not right!"
        exit(1) 
    }
}