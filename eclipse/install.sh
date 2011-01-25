# Based on https://github.com/kremso/cpew/

function die {
	echo $1
	exit 1
}


if [ "$#" = "0" -o "$#" -gt "1" ]; then
	echo "usage: $0 <workspace>"
	exit 1
fi


if [ "$#" = "1" ]; then
	WORKSPACE=$1;
fi

WORKSPACE_DIR=`dirname $WORKSPACE`

if [[ ! ( ( -d "$WORKSPACE_DIR" ) && ( -w "$WORKSPACE_DIR" ) ) ]]; then
	echo $WORKSPACE_DIR is not a writable directory
	exit 1
fi

mkdir -p $WORKSPACE || die Could not create directory $WORKSPACE
mkdir -p $WORKSPACE/.metadata/.plugins/org.eclipse.core.runtime/ || die Could not create eclipse settings directory
cp -R . $WORKSPACE/.metadata/.plugins/org.eclipse.core.runtime/ || die Could not copy old settings

echo New workspace created. Now start your Eclipse and point it to the $WORKSPACE workspace





cp -R * $1//.metadata/.plugins/org.eclipse.core.runtime/
