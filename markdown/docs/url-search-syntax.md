#Url Search Syntax


We offer a method of searching URLs very similar to Grunts file globing.


### Special Characters
* `*`  Matches zero or more characters but not `/`
* `?`  Matches one character but not `/`
* `**` Matches all characters including `/`
* `{}` Allows for a comma-separated list of "or" expressions
* `!`  At the beginning of a pattern, will negate the match
* `$`  Escape character

_All special characters must be escaped including the escape character._

### Basic Searching
```coffeescript
#if URL is google.com or google.co.uk but not google.com/fonts
"**google.*"

#if URL contains the word Google
"**google**"
```


### Or Condition
```coffeescript
#if URL contains Google, Apple, or Microsoft
"**{google,apple,microsoft}**"

#or inception
"{cake,apple{pie,tart}}"

#this or blank
"{this,}"
```


### Not Condition
```coffeescript
#if URL does not contain Google
"!**google**"

#! must come at the beginning of the
#statement or it will be taken literally
"x!y" #url is x!y
"!xy" #url is not xy
```


### Escaping
```coffeescript
#if url is literally "*"
"$*"

#escaping the escape character
"$$"

#you have to escape each character
"$*$*"
```


### More Examples
| URL          | Syntax                             |
|--------------|------------------------------------|
| Any URL      | `**`                               |
| All HTTPS    | `!https**`                         |
| Google+      | `*{//,}plus.google.*`              |
| Google.com   | `*{//,//www.,www.,}google.*`       |
| Chrome Store | `*{//,}chrome.google.*/webstore`   |
| Google Fonts | `*{//,//www.,www.,}google.*/fonts` |
