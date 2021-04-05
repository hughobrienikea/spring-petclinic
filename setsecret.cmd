
@echo off
oc whoami --show-token >openshift.login.token
set /P LOGINQ=< openshift.login.token
del openshift.login.token
Set LOGIN=%LOGINQ:"=%

oc whoami --show-server >openshift.server
set /P SERVERQ=< openshift.server
del openshift.server
Set SERVER=%SERVERQ:"=%
rem echo  The server is /%SERVER%/
rem echo  The token is  /%LOGIN%/
 
echo  Server: %SERVER%
echo  Registry: quay.io
echo.

gh secret set OPENSHIFT_SANDBOX_URL -b %SERVER%
gh secret set OPENSHIFT_SANDBOX_TOKEN -b %LOGIN%
 
IF "%MY_QUAY_PW%"=="" (GOTO :missing_reg_token) 
gh secret set REGISTRY_PASSWORD -b %MY_QUAY_PW%

echo This app will be running on /%SERVER%/
echo Workflow is configured to the following registry, user,namespace, app name and port 
echo.
yq r .github\workflows\petclinic-sample.yaml env.IMAGE_REGISTRY   
yq r .github\workflows\petclinic-sample.yaml env.REGISTRY_USER  
yq r .github\workflows\petclinic-sample.yaml env.TEST_NAMESPACE   
yq r .github\workflows\petclinic-sample.yaml env.APP_NAME   
yq r .github\workflows\petclinic-sample.yaml env.APP_PORT  

goto :end


:missing_reg_token
echo missing REGISTRY_PASSWORD

:end