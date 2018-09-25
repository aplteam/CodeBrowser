# CodeBrowser


## Overview

CodeBrowser allows you to create a stand-alone HTML document with APL code. Its purpose is to provide a tool for documentation and code reviews.

The HTML carries plenty of links. That makes it easy to jump around when reviewing code.

The CSS is optimized for printing the document in order to make it look nice.

[**Demo:** CodeBrowser processing itself](http://htmlpreview.github.com/?https://github.com/aplteam/CodeBrowser/blob/master/CodeBrowser_CodeReview.html)


## Installation

Make sure that the contents of the zip file goes into a folder that is scanned by Dyalog APL for user commands.

Any newly started instance of Dyalog APL then knows a user commands `]CodeBrowser`.

Enter 

```
]CodeBrowser -?
```

for how to run the user command (reference)

For a detailed documentation including examples enter

```
]CodeBrowser -??
```

The simplest example:

```
]CodeBrowser ⎕se -view
```

The `-view` flag stands for `view in default browser`. This will allow you to see everything in `⎕SE`.


## Parameters

Although many (though not all) parameters can be specified as flags and options via the user command in order to make it possible to run CodeBrowser under program control, for a user the most convenient way is certainly to make use of the `-gui` flag.

This lets the user command show a GUI that allows the user to comfortably define all parameters she wants to amend:

![](http://htmlpreview.github.com/?https://github.com/aplteam/CodeBrowser/blob/master/CodeBrowser/images/gui_1.png "First tab of CodeBrowser's GUI")

![](http://htmlpreview.github.com/?https://github.com/aplteam/CodeBrowser/images/gui_1.png "Second tab of CodeBrowser's GUI")

![](CodeBrowser/images/gui_1.png "Third tab of CodeBrowser's GUI")


...