:Class  CodeBrowser
⍝ User Command script for "CodeBrowser"
⍝ The workspace "CodeBrowse.dws" must be a sibling of this user command script.
⍝ The WS is copied into a namespace ⎕SE.CodeBrowser which is deleted afterwards except when -load is specified.
⍝ Kai Jaeger ⋄ APL Team Ltd
⍝ Version 1.0.0 - 2018-04-17

    ∇ r←List;⎕IO;⎕ML
      :Access Shared Public
      ⎕IO←⎕ML←1
      r←⎕NS''
      r.Name←'CodeBrowser'
      r.Desc←'Starts "CodeBrowser"'
      r.Group←'Tools'
      r.Parse←'-ignore= -caption= -filename= -footer= -info= -r= -vib -twosided -pfs= -obj= -lang= -p -load -gui'
    ∇

    ∇ r←Run(Cmd Args);⎕IO;⎕ML;parms;ref;CR
      :Access Shared Public
      ⎕IO←1 ⋄ ⎕ML←1 ⋄ ⎕WX←3
      :If Args.load
          ⎕SE.⎕EX'CodeBrowser'
          'CodeBrowser'⎕SE.⎕NS''
          'Could not find/load CodeBrowser'⎕SIGNAL 11/⍨~Load ⍬
          ⎕SE.CodeBrowser.⎕FX↑'r←parms Run namespaces' 'r←parms CodeBrowser.Run namespaces'
          ⎕SE.CodeBrowser.⎕FX 'r←CreateParms dummy' ('r←CodeBrowser.CreateParms ''',((⊃⎕NPARTS ##.SourceFile),'CodeBrowser'),'''')
          CR←⎕UCS 13
          ⎕←'CodeBrowser loaded into ⎕SE. Call:',CR,' parms←⎕SE.CodeBrowser.CreateParms ⍬',CR,'and',CR,' parms ⎕SE.CodeBrowser.Run #'
          r←''
      :ElseIf Args.gui
          'Don''t specify any other flags with -gui'⎕SIGNAL 11/⍨1≠⍴,Args.gui
          ⎕SE.⎕SHADOW'CodeBrowser'
          ref←⍎'CodeBrowser'⎕SE.⎕NS''
          'Could not find/load CodeBrowser'⎕SIGNAL 11/⍨~Load CodeBrowser
          r←ref.CodeBrowser.GUI.Run Args.Arguments((⊃⎕NPARTS ##.SourceFile),'/CodeBrowser')
      :Else
          'No namespace(s) specified'⎕SIGNAL 11/⍨0∊⍴Args.Arguments
          ⎕SE.⎕SHADOW'CodeBrowser'
          ref←⍎'CodeBrowser'⎕SE.⎕NS''
          'Could not find/load CodeBrowser'⎕SIGNAL 11/⍨~Load CodeBrowser
          parms←ref.CodeBrowser.CreateParms(⊃⎕NPARTS ##.SourceFile),'/CodeBrowser'
          parms←parms Args2Parms Args
          :If ~0∊⍴parms.ignore
              parms.ignore←' 'ref.APLTreeUtils.Split ref.APLTreeUtils.dmb parms.ignore
              parms.ignore←({⊃⍵↓⍨+/∧\'⎕'=⊃¨⍵}⎕NSI)∘{0<⎕NC ⍵:⍵ ⋄ ⍺,'.',⍕⍵}¨parms.ignore
          :EndIf
          r←parms ref.CodeBrowser.Run Args.Arguments
      :EndIf
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
          r,←⊂'-gui=       Puts a GUI on display. You may specify namespace(s) with -gui but no other flags.'
          r,←⊂'-info=      No default. Ordinary text that goes underneath the main header ("caption"). No HTML please.'
          r,←⊂'-lang=      "language"; defaults to "en".'
          r,←⊂'-p          Add table with parameters to the end of the document with a page break before the table.'
          r,←⊂'-r          Recursive; defaults to 1. Must be a Boolean.'
          r,←⊂'-vib        View In Browser. Boolean that defaults to 0.  A 1 shows the HTML in your default browser.'
          r,←⊂'-twosided   Boolean that defaults to 0. Two-side prints have different left margins on odd/even pages.'
          r,←⊂'-pfs=       Print Font Size. Defaults to 8. Must be numeric (pt).'
          r,←⊂'-obj=       f=function, g=GUI (only when KeepOnClose is 1), o=operators, v=variables, s=scripts (classes, interfaces, namespaces).'
          r,←⊂'-load       If you specify this flag then all other flags are ignored. CodeBrowser is copied into ⎕SE.'
          r,←⊂'            You then have two functions at your disposal ⎕SE.CodeBrowser: CreateParms and Run.'
      :Case 1
          ⎕SE.⎕SHADOW'CodeBrowser'
          ref←⍎'CodeBrowser'⎕SE.⎕NS''
          'Could not find/load CodeBrowser'⎕SIGNAL 11/⍨~Load ⍬
          {}⎕SE.UCMD']ADOC ⎕SE.CodeBrowser.CodeBrowser'
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
              ⎕SE.CodeBrowser.⎕CY thisPath,'\CodeBrowser\CodeBrowser.dws'
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
          parms.processGuiInstances←∨/'Gu'∊args.obj
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
