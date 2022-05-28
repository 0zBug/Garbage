# Garbage
**A simple module to edit values in the garbage collection**
## tiny.lua
**tiny.lua has a different dump function to return less and more relevant results, however it is less performant.**
# Documentation
### find
**Finds upvalues and constants related to the query.**
```html
<table> Garbage.find(<string> Query)
```
### dump
**Finds and outputs tables in the collection.**
```html
<table> Garbage.dump(<string> Query)
```
### setupvalue
**Edits the value of an value in the collection.**
```html
<void> Garbage.setupvalue(<string> Query, <string> Index, <?> Value, <boolean> Changed)
```
