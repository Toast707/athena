#-----------------------------------------------------------------------
# TITLE:
#   vardiff_control.tcl
#
# AUTHOR:
#   Will Duquette
#
# DESCRIPTION:
#   athena(n) history variable differences: control.n.
#
#   A value is the name of the actor controlling the neighborhood, or
#   "" if none.
#
#   NOTE: Ideally this vardiff would drill down to influence.n.a. However,
#   since *when* control shifts is important the current methodology
#   of looking at end times of cases is not sufficient in telling the
#   story.  In fact, it is completely misleading.  Once a more suitable
#   way of drilling down to influence is established then it can be 
#   added in.
#
#-----------------------------------------------------------------------

oo::class create ::athena::vardiff::control {
    superclass ::athena::vardiff
    meta type       control
    meta category   political
    meta normfunc   1.0
    meta leaf       1
    meta primary    1
    meta inputTypes {}

    constructor {comp_ val1_ val2_ n_} {
        next $comp_ [list n $n_] $val1_ $val2_  
    }

    method format {val} {
        if {$val ne ""} {
            return $val
        } else {
            return "*NONE*"
        }
    }

    method fancy {val} {
        if {$val ne ""} {
            return "Actor $val is in control"
        } else {
            return "No actor is in control"
        }
    }

    method delta {} {
        # All symbolic differences are equally important.
        return [expr {1.0}]
    }

    method narrative {} {
        return "Neighborhood [my key n] was controlled by [my fmt1], is controlled by [my fmt2]."
    }
}


