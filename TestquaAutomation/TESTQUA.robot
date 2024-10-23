*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary

*** Variables ***
${SITE}             http://www.testsaguisaquijano.somee.com

*** Test Cases ***
Open Browser
    Open Browser    ${SITE}    browser=edge
    Set Window Size    1600     900

Check Landing Page
    ${CURRENTURL}   Get Location
    Create Session    my_session    ${SITE}
    ${response}=    GET On Session    my_session    /
    Should Be Equal As Numbers    ${response.status_code}    200