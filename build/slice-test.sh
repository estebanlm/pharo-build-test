#! /bin/bash

# DOWNLOAD THE EXTERNAL HTML RESOURCES
wget --quiet \
	--mirror --no-parent \
    --reject "*.html*" \
    --no-host-directories \
    --directory-prefix bootstrap \
    --cut-dirs=2 \
    http://files.pharo.org/extra/bootstrap/

wget --quiet -O - get.pharo.org/50+vm | bash

# PREPARE CI
echo "Prepare CI"
./pharo Pharo.image save ci --delete-old
./pharo ci.image config http://smalltalkhub.com/mc/Pharo/ci/main ConfigurationOfCI --install=stable
# EXECUTE TESTS
echo "Execute tests"
./pharo ci.image ci slice test --html-resources="./bootstrap/" --update-issue --next