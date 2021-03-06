#-----------------------------------------------------------------------
# TITLE:
#   vardiff_driversat.tcl
#
# AUTHOR:
#   Will Duquette
#
# DESCRIPTION:
#   athena(n) variable differences: driversat.g.c.drid
#
#   A value is the total contribution of a driver to a particular curve.
#
#-----------------------------------------------------------------------

oo::class create ::athena::vardiff::driversat {
    superclass ::athena::vardiff
    meta type       driversat
    meta category   social
    meta normfunc   maxabs
    meta primary    0
    meta leaf       1
    meta inputTypes {}

    constructor {comp_ val1_ val2_ g_ c_ drid_} {
        next $comp_ [list g $g_ c $c_ drid $drid_] $val1_ $val2_
    }

    method format {val} {
        return [format %.1f $val]
    }

    method fancy {val} {
        return "[format %.1f $val] points"
    }
    
    method context {} {
        return {<i>x</i> &ge; 0.0}
    }

    method narrative {} {
        return [my DeltaNarrative \
            "Total contribution by driver [my key drid] to group [my key g]'s satisfaction with [my key c]" \
            "satisfaction points"]
    }


}