#!/bin/bash -x

#PROJECT=FOX
#GITHUB=https://github.com/AKSW
#GITHUB=https://github.com/DrSnowbird

echo "#### ---- WORK DIR: `pwd` ----"

echo "... Create ${WORKDIR} directory"
mkdir -p ${WORKDIR}
cd ${WORKDIR}

echo "#### ---- GIT Source Code ----"
echo "... Clone the latest from GIT"
if [ ! -e ${WORKDIR}/${PROJECT} ]; then
    git clone -b master ${GITHUB}/${PROJECT}.git
fi

echo "... Change dir into ${WORKDIR}/${PROJECT}"
cd ${WORKDIR}/${PROJECT}

if [! -e ${WORKDIR}/FOX/fox.properties ]; then
    cp fox.properties-dist fox.properties
fi

echo "#### ---- DEPENDENCIES ----"
pkg_list="maven graphviz"
for pkg in $pkg_list; do
    if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
         echo "----: INFO: ${pkg} is already installed"
    else
        echo "----: INFO: Install ${pkg} libarary"
        echo "sudo apt-get install -y $pkg"
        echo
    fi
done

echo "#### ---- BUILD ----"
echo "... Build the ${PROJECT} release: "
## -- Build's command --
    nohup mvn clean compile package -Dmaven.test.skip=false javadoc:javadoc > build.log &
    echo "--- SUCCESS:  build/install ${PROJECT} release!"
else
    echo "Couldn't build ${PROJECT} release!"
fi


exit 0
 
############ USE learn-and-run.sh instead of the following code #############
#############################################################################
######################### FOX Learn-and-Run phases ##########################
#############################################################################

echo "... Starting the ${PROJECT} release: "

# Go into the release folder and 
# rename fox.properties-dist to fox.properties and change the file to your needs.
# cd release

# Learn with trainings data (optional with default properties file): 
# ./learn.sh 

# (set org.aksw.fox.nerlearner.FoxClassifier.training to true in fox.properties)
# Start the server: 
#./run.sh

# Stop the server: 
# ./close.sh

