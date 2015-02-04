#-----------------------------------------------------------------------
# TITLE:
#    pkgModules.tcl
#
# PROJECT:
#    athena - Athena Regional Stability Simulation
#
# DESCRIPTION:
#    athena(n) package modules file
#
#    Generated by Kite.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Package Definition

# -kite-provide-start  DO NOT EDIT THIS BLOCK BY HAND
package provide athena 6.3.0a5
# -kite-provide-end

#-----------------------------------------------------------------------
# Required Packages

# Add 'package require' statements for this package's external 
# dependencies to the following block.  Kite will update the versions 
# numbers automatically as they change in project.kite.

# -kite-require-start ADD EXTERNAL DEPENDENCIES
package require projectlib
# -kite-require-end

namespace import ::projectlib::*

#-----------------------------------------------------------------------
# Namespace definition

namespace eval ::athena:: {
    variable library [file dirname [info script]]
}

#-----------------------------------------------------------------------
# Modules

# Used to define and query orders.
::marsutil::order_set create ::athena::orders ::athena::athena_order {adb}

source [file join $::athena::library athena.tcl       ]
source [file join $::athena::library athenadb.tcl     ]
source [file join $::athena::library athena_order.tcl ]
source [file join $::athena::library athena_flunky.tcl]
source [file join $::athena::library dynatypes.tcl    ]

# Editable Entities
source [file join $::athena::library absit.tcl        ]
source [file join $::athena::library actor.tcl        ]
source [file join $::athena::library bsys.tcl         ]
source [file join $::athena::library cap.tcl          ]
source [file join $::athena::library civgroup.tcl     ]
source [file join $::athena::library coop.tcl         ]
source [file join $::athena::library frcgroup.tcl     ]
source [file join $::athena::library hrel.tcl         ]
source [file join $::athena::library nbhood.tcl       ]
source [file join $::athena::library orggroup.tcl     ]
source [file join $::athena::library sat.tcl          ]
source [file join $::athena::library vrel.tcl         ]

# Non-Editable Entities
source [file join $::athena::library activity.tcl     ]
source [file join $::athena::library agent.tcl        ]

