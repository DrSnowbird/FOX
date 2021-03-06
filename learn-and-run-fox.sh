#!/bin/bash -x

#PROJECT=FOX
#GITHUB=https://github.com/AKSW
#GITHUB=https://github.com/DrSnowbird

#### ---- Java runtime Memory: ----
XMX=${XMX:-8G}

### --- FOX JAR ---
FOX_JAR=fox-2.3.0-jar-with-dependencies.jar

#### ---- Supported Languages: de (default), en ----
#LNG=${LNG:-de}
LNG=${LNG:-en}

LOG_LEARN="learn.log"
LOG_RUN="run.log"

cd ./release
echo "----: INFO: Current WORK Dir=`pwd`"

#### ---- Prepare FOX Properties file: ----
if [ ! -e ./fox.properties ]; then
    if [ ! -e ./fox.properties-dist ]; then
        echo "****: ERROR: learn-and-run: missing FOX property dist file: ${WORKDIR}/FOX/fox.properties-dist "
        exit 1
    else
        cp fox.properties-dist fox.properties
    fi
fi

if [ ! -e ./fox.properties ]; then
    echo "ERROR: learn-and-run: missing FOX property file!"
    exit 1
fi

#### ---- Switch FOX Properties "training: true" ----
sed -i -e 's#training: false#training: true#g' 'fox.properties'

#### ---- Training Corpus for Germany (default) ----
#java -Xmx8G -cp fox-2.3.0-jar-with-dependencies.jar org.aksw.fox.FoxCLI -len -atrain -iinput/Wikiner/aij-wikiner-en-wp3.bz2
java -Xmx${XMX} -cp ${FOX_JAR} org.aksw.fox.FoxCLI -l${LNG} -atrain -iinput/Wikiner/aij-wikiner-${LNG}-wp3.bz2 | tee ${LOG_LEARN}

#### ---- Switch FOX Properties "training: false" ----
sed -i -e 's#training: true#training: false#g' 'fox.properties'

#### ---- Run FOX:  ----
#java -Xmx8G -cp fox-2.3.0-jar-with-dependencies.jar org.aksw.fox.FoxRESTful -len
java -Xmx${XMX} -cp ${FOX_JAR} org.aksw.fox.FoxRESTful -l${LNG} | tee ${LOG_RUN}


