:Class  CodeBrowser
⍝ User Command script for "CodeBrowser"
⍝ The workspace "CodeBrowse.dws" must be a sibling of this user command script.
⍝ The WS is copied into a namespace ⎕SE.CodeBrowsaer___ which is deleted afterwards.
⍝ Kai Jaeger ⋄ APL Team Ltd
⍝ Version 1.0.0 - 2018-03-26

    ∇ r←List;⎕IO;⎕ML ⍝ this function usually returns 1 or more namespaces (here only 1)
      :Access Shared Public
      ⎕IO←⎕ML←1
      r←⎕NS''                               ⍝ create the command
      r.Name←'CodeBrowser'                  ⍝ name
      r.Desc←'Starts "CodeBrowser"'
      r.Group←'Tools'
     ⍝ Parsing rules for each:
      r.Parse←'1L -ignore= -caption= -filename= -footer= -info= -r= -vib -twosided -pfs= -obj= -lang= -p'
    ∇

    ∇ r←Run(Cmd Args);⎕IO;⎕ML;parms;namespaceList;ref
      :Access Shared Public
      ⎕IO←1 ⋄ ⎕ML←1 ⋄ ⎕WX←3
      ⎕SE.⎕SHADOW'CodeBrowser___'
      ref←⍎'CodeBrowser___'⎕SE.⎕NS''
      'Could not find/load CodeBrowser'⎕SIGNAL 11/⍨~Load ⍬
      parms←ref.CodeBrowser.CreateParms
      parms←parms Args2Parms Args
      :If ~0∊⍴parms.ignore
          parms.ignore←' 'ref.APLTreeUtils.Split ref.APLTreeUtils.dmb parms.ignore
          parms.ignore←({⊃⍵↓⍨+/∧\'⎕'=⊃¨⍵}⎕NSI)∘{0<⎕NC ⍵:⍵ ⋄ ⍺,'.',⍕⍵}¨parms.ignore
      :EndIf
      namespaceList←' 'ref.APLTreeUtils.Split ref.APLTreeUtils.dmb⊃Args.Arguments
      namespaceList←({⊃⍵↓⍨+/∧\'⎕'=⊃¨⍵}⎕NSI)∘{0<⎕NC ⍵:⍵ ⋄ ⍺,'.',⍕⍵}¨namespaceList
      r←parms ref.CodeBrowser.Run namespaceList
    ∇

    ∇ r←level Help Cmd;⎕IO;⎕ML;ref
      ⎕IO←1 ⋄ ⎕ML←1
      :Access Shared Public
      r←''
      :Select level
      :Case 0
          r,←⊂'Starts CodeBrowser. Specify namespace(s) to be investigated as argument.'
          r,←⊂'Loads CodeBrowser (and some stuff needed by CodeBrowser) into ⎕SE and starts it.'
          r,←⊂''
          r,←⊂'There are plenty of switches available to make CodeBrowser suit your needs:'
          r,←⊂''
          r,←⊂'-ignore=    List of space or comma-separated namespace names to be ignored.'
          r,←⊂'-caption=   Defaults to the list of namespaces to be scanned.'
          r,←⊂'-filename=  Defaults to a temp filename.'
          r,←⊂'-footer=    No default. If specified it goes underneath a horizontal line at the bottom of the document.'
          r,←⊂'-info=      No default. Ordinary text that goes underneath the main header ("caption"). No HTML please.'
          r,←⊂'-lang=      "language"; defaults to "en".'
          r,←⊂'-p          Add table with parameters to the end of the document with a page break before the table.'
          r,←⊂'-r          Recursive; defaults to 1. Must be a Boolean.'
          r,←⊂'-vib        View In Browser. Boolean that defaults to 0.  A 1 shows the HTML in your default browser.'
          r,←⊂'-twosided   Boolean that defaults to 0. Two-side prints have different left margins on odd/even pages.'
          r,←⊂'-pfs=       Print Font Size. Defaults to 8. Must be numeric (pt).'
          r,←⊂'-obj=       f=function, o=operators, v=variables, s=scripts (classes, interfaces, namespaces).'
      :Case 1
          ⎕SE.⎕SHADOW'CodeBrowser___'
          ref←⍎'CodeBrowser___'⎕SE.⎕NS''
          'Could not find/load CodeBrowser'⎕SIGNAL 11/⍨~Load ⍬
          {}⎕SE.UCMD']ADOC ⎕SE.CodeBrowser___.CodeBrowser'
          r,←⊂'Watch your default browser'
      :Case 2
          r←⊂'Not available'
      :EndSelect
    ∇

    ∇ r←{default}ReadRegKey key;wsh;⎕WX
     ⍝ Read a registry key. Uses a particular default path which can be overridden via the left argument
      :Access public shared
      ⎕WX←1
      default←{0<⎕NC ⍵:⍎⍵ ⋄ ''}'default'
      'wsh'⎕WC'OLEClient' 'WScript.Shell'
      :Trap 11
          r←wsh.RegRead key
      :Else
          r←default
      :EndTrap
    ∇

      Split←{
          ⎕ML←⎕IO←1
          ⍺←⎕UCS 13 10 ⍝ Default is CR+LF
          (⍴,⍺)↓¨⍺{⍵⊂⍨⍺⍷⍵}⍺,⍵
      }

    ∇ success←Load dummy;rk;regData;paths;thisPath
      success←0
      rk←'HKEY_CURRENT_USER\Software\Dyalog\Dyalog APL/W'
      rk,←('64'≡¯2↑1⊃'.'⎕WG'APLVersion')/'-64'
      rk,←' ',{⍵/⍨2>+\'.'=⍵}2⊃'.'⎕WG'APLVersion'
      rk,←(80=⎕DR' ')/' Unicode'
      rk,←'\SALT\CommandFolder'
      regData←ReadRegKey rk
      ((regData∊'∘°')/regData)←';'
      paths←';'Split regData
      :For thisPath :In paths
          :Trap 11
              ⎕SE.CodeBrowser___.⎕CY thisPath,'\CodeBrowser\CodeBrowser.dws'
              success←1
              :Leave
          :EndTrap
      :EndFor
    ∇

    ∇ parms←parms Args2Parms args
      :If 0≢args.ignore
          '"ignore": invalid data type'⎕SIGNAL 11/⍨' '≠1↑0⍴∊args.ignore
          parms.ignore←args.ignore
      :EndIf
      :If 0≢args.caption
          '"caption": invalid data type'⎕SIGNAL 11/⍨' '≠1↑0⍴∊args.caption
          parms.caption←args.caption
      :EndIf
      :If 0≢args.footer
          '"footer": invalid data type'⎕SIGNAL 11/⍨' '≠1↑0⍴∊args.footer
          parms.footer←args.footer
      :EndIf
      :If 0≢args.filename
          '"filename": invalid data type'⎕SIGNAL 11/⍨' '≠1↑0⍴∊args.filename
          parms.filename←args.filename
      :EndIf
      :If 0≢args.info
          '"info": invalid data type'⎕SIGNAL 11/⍨' '≠1↑0⍴∊args.info
          parms.info←args.info
      :EndIf
      :If 0≢args.pfs
          '"pfs" (print font size) is not numeric'⎕SIGNAL 11/⍨(,1)≢,⊃⎕VFI args.pfs
          parms.printFontSize←args.pfs
      :EndIf
      :If 0≢args.obj
          '"obj": invalid data type'⎕SIGNAL 11/⍨' '≠1↑0⍴∊args.obj
          parms.processScripts←∨/'sS'∊args.obj
          parms.processFunctions←∨/'fF'∊args.obj
          parms.processOperators←∨/'Oo'∊args.obj
          parms.processVars←∨/'Vv'∊args.obj
      :EndIf
      :If 0≢args.r
          '"recursive" is not a Boolean'⎕SIGNAL 11/⍨0=1↑∊⎕VFI args.r
          '"recursive" is not a Boolean'⎕SIGNAL 11/⍨~(∊(//)⎕VFI args.r)∊0 1
          parms.recursive←∊(//)⎕VFI args.r
      :EndIf
      :If 0≢args.lang
          '"lang" is not text like "en"'⎕SIGNAL 11/⍨~(1=≡args.lang)∧(' '=1↑0⍴∊args.lang)∧(2=⍴,args.lang)
          parms.lang←args.lang
      :EndIf
      parms.viewInBrowser←Args.Switch'vib'
      parms.showParms←Args.Switch'p'
      parms.twoSidedPrint←Args.Switch'twosided'
    ∇

:EndClass