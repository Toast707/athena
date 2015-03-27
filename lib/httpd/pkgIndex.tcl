# Tcl package index file, version 1.1

# This file is generated by the MakeIndex script in the tclhttpd 
# lib directory.  The goal is to not pollute the package namespace
# until you package require httpd

package ifneeded httpd 1.7 "
	source \[file join [list $dir] httpd.tcl\]
	package ifneeded httpd::auth 2.0 \[list source \[file join [list $dir] auth.tcl\]\]
	package ifneeded httpd::cgi 1.1 \[list source \[file join [list $dir] cgi.tcl\]\]
	package ifneeded httpd::digest 1.0 \[list source \[file join [list $dir] digest.tcl\]\]
	package ifneeded httpd::opentrace 1.0 \[list source \[file join [list $dir] open.tcl\]\]
	package ifneeded httpd::passcheck 1.0 \[list source \[file join [list $dir] passcheck.tcl\]\]
	package ifneeded httpd::passgen 1.0 \[list source \[file join [list $dir] passgen.tcl\]\]
	package ifneeded httpd::session 1.0 \[list source \[file join [list $dir] session.tcl\]\]
	package ifneeded httpd::utils 1.0 \[list source \[file join [list $dir] utils.tcl\]\]
	package ifneeded tclcrypt 1.0 \[list source \[file join [list $dir] tclcrypt.tcl\]\]
"
