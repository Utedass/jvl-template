# Add all signals from the top level of test bench
# i.e. only containing one . character
set nfacs [ gtkwave::getNumFacs ]
puts "Totally $nfacs number of facilities"

set top_facs [list]
for {set i 0} {$i < $nfacs } {incr i} {
    set facname [ gtkwave::getFacName $i ]
	puts "Evaluating: $facname"
	set matches [regexp -all {\.} $facname]
	if {$matches == 2} {
		set has_index [regexp -all {\[.*\]} $facname]
		if {$has_index >= 1} {
			set is_index_zero [regexp -all {\[0\]} $facname]
			if {$is_index_zero >= 1} {
				lappend top_facs "$facname"
				puts "Added signal: $facname"
			}
		} else {
			lappend top_facs "$facname"
			puts "Added signal: $facname"
		}
	}
}

set dut_facs [list]
for {set i 0} {$i < $nfacs } {incr i} {
    set facname [ gtkwave::getFacName $i ]
	set matches [regexp -all {dut} $facname]
	
	if {$matches > 0} {
		set matches [regexp -all {\.} $facname]
		if {$matches == 3} {
			set has_index [regexp -all {\[.*\]} $facname]
			if {$has_index >= 1} {
				set is_index_zero [regexp -all {\[0\]} $facname]
				if {$is_index_zero >= 1} {
					lappend dut_facs "$facname"
					puts "Added signal: $facname"
				}
			} else {
				lappend dut_facs "$facname"
				puts "Added signal: $facname"
			}
		}
	}
}

set num_top_added [ gtkwave::addSignalsFromList $top_facs ]

gtkwave::/Edit/Insert_Blank
gtkwave::/Edit/Insert_Blank

set num_dut_added [ gtkwave::addSignalsFromList $dut_facs ]
puts "num top signals added: $num_top_added"
puts "num DUT signals added: $num_dut_added"

# zoom full
gtkwave::/Time/Zoom/Zoom_Full