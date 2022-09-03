# Heimdallr

```
   _   _      _               _       _ _      
  | | | | ___(_)_ __ ___   __| | __ _| | |_ __ 
  | |_| |/ _ \ | '_ ` _ \ / _` |/ _` | | | '__|
  |  _  |  __/ | | | | | | (_| | (_| | | | |   
  |_| |_|\___|_|_| |_| |_|\__,_|\__,_|_|_|_|   
 
              yhng.zhu@gmail.com 
```

## Introduction

Heimdallr is a universal IC front-end project structure, including aligorithms, rtl implementations,
verification environments, related script tools, etc.

## Hierarchy

Heimdallr's hierarchy as follows:

```

.
|-- DOC
|-- PRJ
|   |-- alg
|   |-- rtl
|   |   |-- filelist
|   |   |-- module
|   |   `-- top
|   `-- verif
|       |-- envir
|       |-- profile
|       |   |-- alia.sh
|       |   |-- path.sh
|       |   |-- prj.sh
|       |   `-- tool.sh
|       `-- script
|           `-- HSIM
|               |-- hsim2.mk
|               `-- hsim3.mk
|-- LICENSE
`-- README.md

```


##Tools

1. HSIM

HSIM is a simulation script responsible for the simulation and regression of single and multiple
use cases. HSIM body is written by makefile and python and is mainly used in the field of
verification.

2. Adaptools

Adaptools is an environment script responsible for generating the corresponding general environment
structure and common simulation use cases. Its body is written by python.



