#!/bin/bash
# HepSim setup toolkit.
# This is a part of the HepSim http://atlaswww.hep.anl.gov/hepsim 
# S.Chekanov (ANL)

if [ ! -n "$BASH" ] ;then echo Please run this script $0 with bash; exit 1; fi

export CFILE="./hepsim.jar"
export HEPSIM_DIR=`pwd`
if [ ! -f $CFILE ];
then
   export HEPSIM_DIR="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"
fi
#chmod 755 $HEPSIM_DIR/*
export PATH="$HEPSIM_DIR:$PATH"

HEPSIM_VERSION="http://atlaswww.hep.anl.gov/asc/hepsim/version"

WWW_VERSION=-1
MIN_VERSION=0


# try wget
fcheck=`type -p wget`
if test -x "$fcheck";
then
    WWW_VERSION=`wget -q $HEPSIM_VERSION -O  - | cat`
fi

# is it numeric?
error=0
if [[ $WWW_VERSION = *[[:digit:]]* ]]; then
 error=0
else
 error=1 # is not numeric  
 WWW_VERSION=-1
fi 


# we have failed with wget, try curl
if [ "$error" -gt "$MIN_VERSION" ] ; then
    fcheck=`type -p curl`
    if test -x "$fcheck";
    then
     WWW_VERSION=`curl -s $HEPSIM_VERSION | cat`
    fi
fi


# is it numeric?
if [[ $WWW_VERSION = *[[:digit:]]* ]]; then
 error=0
else
 error=1 # is not numeric  
 WWW_VERSION=-1
fi

# we have failed with curl as well. Complain 
if [ "$error" -gt "$MIN_VERSION" ] ; then
    echo "Failed to check the version of HS-TOOLS. Please install \"wget\" or \"curl\""
fi

LOCAL_VERSION=1
VERSION_FILE=$HEPSIM_DIR/version
if [ -e $VERSION_FILE ]
then
 LOCAL_VERSION=`cat $VERSION_FILE`	
fi


if [ "$error" -le "$MIN_VERSION" ] 
then
  if [ "$WWW_VERSION" -gt "$LOCAL_VERSION" ] 
  then
    echo "A new version of \"hs-toolkit\" was found. Your version is $LOCAL_VERSION!"
    echo "Please update your installation as explained in" 
    echo "http://atlaswww.hep.anl.gov/hepsim/description.ph"
    echo " "
  fi
fi


# now check for Java
if which java >/dev/null; then
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    _java="$JAVA_HOME/bin/java"
else
    echo "No java detected! Please install it from https://java.com/download"; exit 0
fi

version="1.6"
if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    if [[ "$version" < "1.7" ]]; then
        echo "Java version is less than 1.7. Please update it."; exit 0;
    fi
fi


echo "Setting hs-toolkit-$LOCAL_VERSION (Java $version) from $HEPSIM_DIR"
