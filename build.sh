# Get rid of any running love instances
killall love

sleep 1

BUILD_DIR="build"
DISTRO_DIR="distro"

# Clean up directories
rm -rf ./$DISTRO_DIR
mkdir $DISTRO_DIR

rm -rf ./$BUILD_DIR
mkdir $BUILD_DIR


# Copy files to build dir
cp ./*.lua $BUILD_DIR
cp -r ./src/* $BUILD_DIR

cd $BUILD_DIR

zip -rj ../$DISTRO_DIR/ping.love ./*

cd ..

# rm -rf $BUILD_DIR # Disable if we want to inspect output


open ./distro/ping.love
