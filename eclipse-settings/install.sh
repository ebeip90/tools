# Based on https://github.com/kremso/cpew/

set -ex

if [ "$#" != "1"]; then
	echo "usage: $0 <workspace>"
	exit 1
fi


WORKSPACE=$1;
WORKSPACE_DIR=`dirname $WORKSPACE`

if [[ ! ( ( -d "$WORKSPACE_DIR" ) && ( -w "$WORKSPACE_DIR" ) ) ]]; then
	echo $WORKSPACE_DIR is not a writable directory
	exit 1
fi

mkdir -p $WORKSPACE
mkdir -p $WORKSPACE/.metadata/.plugins/org.eclipse.core.runtime/
cp -R . $WORKSPACE/.metadata/.plugins/org.eclipse.core.runtime/

echo New workspace created. Now start your Eclipse and point it to the $WORKSPACE workspace

cp -R * $1//.metadata/.plugins/org.eclipse.core.runtime/
