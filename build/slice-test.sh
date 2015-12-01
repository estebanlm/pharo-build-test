#! /bin/bash

#fake jenkins (for test, we should remove it later)
export JENKINS_URL=true

# DOWNLOAD THE EXTERNAL HTML RESOURCES
echo -e ""
echo -e "\e[32m======================"
echo -e "\e[32m= DOWNLOAD RESOURCES ="
echo -e "\e[32m======================"
echo -e "\e[0m"
wget --quiet \
	--mirror --no-parent \
    --reject "*.html*" \
    --no-host-directories \
    --directory-prefix bootstrap \
    --cut-dirs=2 \
    http://files.pharo.org/extra/bootstrap/

wget --quiet -O - get.pharo.org/50+vm | bash

# PREPARE CI
echo -e ""
echo -e "\e[32m=============="
echo -e "\e[32m= PREPARE CI ="
echo -e "\e[32m=============="
echo -e "\e[0m"
./pharo Pharo.image save ci --delete-old
./pharo ci.image config http://smalltalkhub.com/mc/Pharo/ci/main ConfigurationOfCI --install=stable
./pharo ci.image eval "(ConfigurationOfCI project version: #stable) versionNumber"

export PHARO_CI_USER=`./pharo ci.image eval "IntegrationManager userName"`
export PHARO_CI_PWD=`./pharo ci.image eval "IntegrationManager password"`

# EXECUTE TESTS
echo -e ""
echo -e "\e[32m================="
echo -e "\e[32m= EXECUTE TESTS ="
echo -e "\e[32m================="
echo -e "\e[0m"
./pharo ci.image ci slice test --html-resources="file://./bootstrap/" --update-issue --next