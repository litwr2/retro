#!/usr/bin/wish
#a widget to load files for XLife
#v1.12, by V.Lidovski, X-2001, IV-2011, VI-2011, VIII-2014

set CSFN /tmp/bk-loadwidget.fn.tmp
set CDIR /tmp/bk-loadwidget.cd.tmp

set libdir .
set homedir ~
set savedir [pwd]

set fi 0
set fn 0
set ds 0
set ls 0

if {[file isdirectory $libdir]} {} else {set libdir $savedir}

set curdir $libdir

if {[file readable $CDIR]} {
  set fi [open $CDIR r]
  gets $fi curdir
  close $fi
  if {[file isdirectory $curdir]} {} else {set curdir $libdir}
}

proc home {} {
  global homedir curdir
  set curdir $homedir
  cd $curdir
  fillflist
}

proc lib {} {
  global curdir libdir
  set curdir $libdir
  cd $curdir
  fillflist
}

proc save {} {
  global curdir savedir
  set curdir $savedir
  cd $curdir
  fillflist
}

proc cur {} {
  global curdir
  cd $curdir
  fillflist
}

proc fillflist {} {
  global curdir ds ls
  .m configure -text $curdir
  .list delete 0 end
  foreach i [lsort [glob [file join $curdir *] [file join $curdir .*]]] {
    if {[file isdirectory $i]} {
      .list insert end [file tail $i]
    }
  }
  .list delete 0 0
  set ds [.list size]
  foreach i [lsort [glob -nocomplain [file join $curdir *.bin] \
                         [file join $curdir *.bkd]]] {
    if {[file isfile $i]} {
      .list insert end [file tail $i]
    }
  }
  set ls [.list size]
  .list activate 0
  .list selection set 0
}

proc execpicend {} {
  global fi fn CDIR CSFN
  set fn [open $CSFN w]
  puts -nonewline $fn $fi
  close $fn
  set fn [open $CDIR w]
  set fi [pwd]
  puts $fn $fi
  close $fn
  exit
}

proc execpat {} {
  global fi fn
  set fi $fi:[.list get active]
  execpicend
}

proc execpic {} {
  global curdir fi ds CSFN
  if {[.list size] == 0} {return}
  set fi [.list get active]
  set i [.list index active]
  if {$i<$ds} {
     cd [file join $curdir $fi]
     set curdir [pwd]
     fillflist
     return
  }
  set fi [file join $curdir $fi]
  set fx [open $fi r]
  set f 0
  .list delete 0 end
  while {! [eof $fx]} {
    set s [gets $fx]
    if {[string first "#B " $s] != 0} {continue}
    set f 1
    set s [string range $s 2 end]
    set s [string trim $s]
    .list insert end $s
  }
  close $fx
  if {$f == 1} {
    wm title . "Select pattern" 
    bind . <Return> execpicend
    .f1.b1 configure -command execpat
    .f1.b3 configure -state disabled
    .f1.b4 configure -state disabled
    .f1.b5 configure -state disabled
    .f1.b6 configure -state normal
    .m configure -text $fi
    .list activate 0
    .list selection set 0
  } else {
    execpicend
  }
}

proc exitpic {} {
  global CSFN fn
#  file delete $CSFN
  set fn [open $CSFN w]
  puts -nonewline $fn "//"
  close $fn
  exit
}

message .m -text $curdir -width 84m -justify center -relief groove
pack .m -side top

listbox .list -yscroll ".scroll set" -width 20 -height 22
pack .list -side left 

scrollbar .scroll -command ".list yview"
pack .scroll -side left -fill y

frame .f1
button .f1.b1 -text OK -width 10 -height 2 -command execpic
button .f1.b2 -text Cancel -width 10 -height 2 -command exitpic
button .f1.b3 -text Library -width 10 -height 2 -command lib
button .f1.b4 -text Home -width 10 -height 2 -command home
button .f1.b5 -text Current -width 10 -height 2 -command save
button .f1.b6 -text All -width 10 -height 2 -command execpicend -state disabled
pack .f1.b1 .f1.b6 .f1.b3 .f1.b4 .f1.b5 .f1.b2
pack .f1

wm title . "Select file" 

cur

fillflist

#focus -force .

bind . <Escape> exitpic
bind . <Control-c> exitpic
bind . <Return> execpic
bind .list <Double-Button-1> execpic
bind . <Down> {
  set i [.list index active]
  .list selection clear $i
  incr i
  if {$i==$ls} {set i [expr $i - 1]}
  .list activate $i
  .list selection set $i
  .list see $i
}
bind . <Up> {
  set i [.list index active]
  .list selection clear $i
  if {$i>0} {set i [expr $i - 1]}
  .list activate $i
  .list selection set $i
  .list see $i
}
bind . <Page_Down> {
  set i [.list index active]
  .list selection clear $i
  set i [expr $i + 20]
  if {$i>=$ls} {set i [expr $ls - 1]}
  .list activate $i
  .list selection set $i
  .list see $i
}
bind . <Page_Up> {
  set i [.list index active]
  .list selection clear $i
  set i [expr $i - 20]
  if {$i<0} {set i 0}
  .list activate $i
  .list selection set $i
  .list see $i
}
bind . <End> {
  set i [.list index active]
  .list selection clear $i
  set i [expr $ls - 1]
  .list activate $i
  .list selection set $i
  .list see $i
}
bind . <Home> {
  set i [.list index active]
  .list selection clear $i
  set i 0
  .list activate $i
  .list selection set $i
  .list see $i
}
