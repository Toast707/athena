#-----------------------------------------------------------------------
# TITLE:
#    helpers.tcl
#
# AUTHOR:
#    Will Duquette
#
# DESCRIPTION:
#    athena(n): Helper Procs
#
#    Useful procs that don't belong anywhere else.
#
#-----------------------------------------------------------------------

# fillparms parmsVar parmdict
#
# parmsVar - An order parms dictionary
# parmdict - An entity attribute dictionary
#
# This command is for use in *:UPDATE order bodies; given the order
# parms and the data for the entity being updated, it fills in the
# empty parameter values in the parmsVar with the existing data.
# this allows for easier cross-validation of parameters.

proc ::athena::fillparms {parmsVar parmdict} {
    upvar 1 $parmsVar parms
    
    foreach parm [array names parms] {
        if {$parms($parm) eq "" && [dict exists $parmdict $parm]} {
            set parms($parm) [dict get $parmdict $parm]
        }
    }
}

# optdict2parmdict dict
#
# dict   - A dictionary in which the keys have option syntax
#
# Returns the same dictionary with "-" stripped from the keys.

proc ::athena::optdict2parmdict {dict} {
    set result [dict create]

    dict for {key value} $dict {
        if {[string index $key 0] eq "-"} {
            set key [string range $key 1 end]
        }

        dict set result $key $value
    }

    return $result
}

# parmdict2optdict dict
#
# dict   - A dictionary in which the keys have option syntax
#
# Returns the same dictionary with "-" added to the keys.

proc ::athena::parmdict2optdict {dict} {
    set result [dict create]

    dict for {key value} $dict {
        if {[string index $key 0] ne "-"} {
            set key "-$key"
        }

        dict set result $key $value
    }

    return $result
}

# lexcept list element
#
# list      - A list
# element   - some element
#
# Returns the list with the element removed (if it was present).

proc ::athena::lexcept {list element} {
    set idx [lsearch -exact $list $element]
    
    if {$idx >= 0} {
        return [lreplace $list $idx $idx]
    } else {
        return $list
    }
}

# andlist noun list
#
# noun   - The noun for the list
# list   - A list of things
#
# Formats the list nicely, whether it contains one, two, or more
# elements.  If the list is empty, returns "<noun> ???"

proc ::athena::andlist {noun list} {
    if {[llength $list] == 0} {
        return "$noun ???"
    } elseif {[llength $list] == 1} {
        return "$noun [lindex $list 0]"
    } elseif {[llength $list] == 2} {
        return "${noun}s [lindex $list 0] and [lindex $list 1]"
    } else {
        set last [lindex $list end]
        set list [lrange $list 0 end-1]

        set text "${noun}s "
        append text [join $list ", "]
        append text " and $last"

        return $text
    }
}


# lprio list item prio
#
# list    A list of unique items
# item    An item in the list
# prio    top, raise, lower, or bottom
#
# Moves the item in the list, and returns the new list.

proc ::athena::lprio {list item prio} {
    # FIRST, get item's position in the list.
    set index [lsearch -exact $list $item]

    # NEXT, get the new position
    let end {[llength $list] - 1}

    switch -exact -- $prio {
        top     { set newpos 0                       }
        raise   { let newpos {max(0,    $index - 1)} }
        lower   { let newpos {min($end, $index + 1)} }
        bottom  { set newpos $end                    }
        default { error "Unknown prio: \"$prio\""    }
    }

    # NEXT, if the item is already in its position, we're done.
    if {$newpos == $index} {
        return $list
    }

    # NEXT, put the item in its list.
    ldelete list $item
    set list [linsert $list $newpos $item]

    # FINALLY, return the new list.
    return $list
}

# caller
# 
# Returns the caller's command, if possible.

proc ::athena::caller {} {
    set dict [info frame -3]

    if {[dict exists $dict cmd]} {
        return [dict get $dict cmd]
    } else {
        return "*unknown*"
    }
}

# dumpstack
#
# Dumps the stack at the current point in execution.  Useful for
# figuring out how a command is called.

proc ::athena::dumpstack {} {
    set i [info frame]

    puts "Stack Frames:"
    for {set i [info frame]} {$i > 0} {incr i -1} {
        array set frm [info frame $i]
        puts "$i: $frm(cmd)"
    }
}



# dbexists db table key value
#
# db    - Database handle
# table - Table name
# key   - Key column name
# value - Key value
#
# Returns 1 if the row exists, and 0 otherwise.

proc ::athena::dbexists {db table key value} {
    return [$db exists "
        SELECT $key FROM $table 
        WHERE $key = \$value
    "]
}

# dbget db table key value ?column?
#
# db     - Database handle
# table  - Table name
# key    - Key column name
# value  - Key value
# column - An optional column name
#
# If the row doesn't exist, returns "".  If it exists, returns the value
# of the specified column, or the entire dictionary.

proc ::athena::dbget {db table key value {column ""}} {
    $db eval "SELECT * FROM $table WHERE $key=\$value" row {
        if {$column ne ""} {
            return $row($column)
        } else {
            unset row(*)
            return [array get row]
        }
    }

    return ""
}

# lequal list1 list2
#
# Returns 1 if the lists are equal and 2 otherwise.
# Sorts the lists before comparing.

proc ::athena::lequal {list1 list2} {
    expr {[lsort $list1] eq [lsort $list2]}
}






