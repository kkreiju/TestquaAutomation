*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary

*** Variables ***
${SITE}             https://localhost:8903/

*** Keywords ***
Open Edge
    Open Browser    ${SITE}    browser=edge
    Maximize Browser Window
Check Status OK
    ${response}=    GET On Session    my_session    /
    Should Be Equal As Numbers    ${response.status_code}    200

Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentsDropdown    timeout=10s
    Click Element    id=StudentsDropdown
    
Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectsDropdown    timeout=10s
    Click Element    id=SubjectsDropdown

*** Test Cases ***
Initialize Browser
    Open Edge
Check Landing Page
    Create Session    my_session    ${SITE}
    Check Status OK

Verify Student Dropdowns
    Sleep    1
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentEntry    timeout=10s
    Click Element    id=StudentEntry
    Check Status OK
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentList    timeout=10s
    Click Element    id=StudentList
    Check Status OK
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentEdit    timeout=10s
    Click Element    id=StudentEdit
    Check Status OK
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentDelete    timeout=10s
    Click Element    id=StudentDelete
    Check Status OK

Add Student Entry
    Sleep    1
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentEntry    timeout=10s
    Click Element    id=StudentEntry
    Check Status OK
    # Case 1: Add a dummy entry and check if cancel works
    Input Text    id=idnumber    123
    Input Text    id=firstname    123
    Input Text    id=middlename    123
    Input Text    id=lastname    123
    FOR    ${index}    IN RANGE    3
        Select From List By Index    id=course    ${index}
    END
    Input Text    id=year    1
    FOR    ${index}    IN RANGE    6
        Select From List By Index    id=remarks    ${index}
    END
    Click Element    id=cancel
    ${idnumber}=    Get Value    id=idnumber
    Should Be Empty    ${idnumber}
    ${firstname}=    Get Value    id=firstname
    Should Be Empty    ${firstname}
    ${middlename}=    Get Value    id=middlename
    Should Be Empty    ${middlename}
    ${lastname}=    Get Value    id=lastname
    Should Be Empty    ${lastname}
    ${year}=    Get Value    id=year
    Should Be Empty    ${year}
    Check Status OK
    # Case 2: Add a dummy entry and check if submit works
    Input Text    id=idnumber    33928124
    Input Text    id=firstname    John
    Input Text    id=middlename    Code
    Input Text    id=lastname    Doe
    Select From List By Index    id=course    0
    Input Text    id=year    1
    Select From List By Index    id=remarks    2
    ${idnumber}=    Get Value    id=idnumber
    Should Be Equal    ${idnumber}    33928124
    ${firstname}=    Get Value    id=firstname
    Should Be Equal    ${firstname}    John
    ${middlename}=    Get Value    id=middlename
    Should Be Equal    ${middlename}    Code
    ${lastname}=    Get Value    id=lastname
    Should Be Equal    ${lastname}    Doe
    ${course}=    Get Selected List Label    id=course
    Should Be Equal    ${course}    BSIT
    ${year}=    Get Value    id=year
    Should Be Equal    ${year}    1
    ${remarks}=    Get Selected List Label    id=remarks
    Should Be Equal    ${remarks}    New
    Click Element   id=submit
    Check Status OK

Verify Added Entry in Student List
    Sleep    1
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentList    timeout=10s
    Click Element    id=StudentList
    Check Status OK
    ${table_text}=    Get Text    xpath=//table[@id='students']//td[contains(text(), '33928124')]
    Should Contain    ${table_text}    33928124

Edit Student Entry
    Sleep    1
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentEdit    timeout=10s
    Click Element    id=StudentEdit
    Check Status OK
    Wait Until Element Is Visible    id=idnumber    timeout=10s
    Input Text    id=idnumber    33928124
    Click Element    id=searchbutton
    # Case 1: Edit the ID Number to another value
    Input Text    id=idnumber2    33928125
    Click Element    id=savebutton
    Check Status OK
    ${table_text}=    Get Text    xpath=//table[@id='students']//td[contains(text(), '33928125')]
    Should Contain    ${table_text}    33928125
    # Case 2: Edit the ID Number back to the original value
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentEdit    timeout=10s
    Click Element    id=StudentEdit
    Check Status OK
    Wait Until Element Is Visible    id=idnumber    timeout=10s
    Input Text    id=idnumber    33928125
    Click Element    id=searchbutton
    Input Text    id=idnumber2    33928124
    Click Element    id=savebutton
    Check Status OK
    ${table_text}=    Get Text    xpath=//table[@id='students']//td[contains(text(), '33928124')]
    Should Contain    ${table_text}    33928124
    # Case 3: Edit the details to another value
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentEdit    timeout=10s
    Click Element    id=StudentEdit
    Check Status OK
    Wait Until Element Is Visible    id=idnumber    timeout=10s
    Input Text    id=idnumber    33928124
    Click Element    id=searchbutton
    Wait Until Element Is Visible    id=firstname    timeout=10s
    Input Text    id=firstname    Jonathan
    Input Text    id=middlename    Doe
    Input Text    id=lastname    Code
    Select From List By Index    id=course    1
    Input Text    id=year    2
    Select From List By Index    id=remarks    3
    ${idnumber}=    Get Value    id=idnumber2
    Should Be Equal    ${idnumber}    33928124
    ${firstname}=    Get Value    id=firstname
    Should Be Equal    ${firstname}    Jonathan
    ${middlename}=    Get Value    id=middlename
    Should Be Equal    ${middlename}    Doe
    ${lastname}=    Get Value    id=lastname
    Should Be Equal    ${lastname}    Code
    ${course}=    Get Selected List Label    id=course
    Should Be Equal    ${course}    BSIS
    ${year}=    Get Value    id=year
    Should Be Equal    ${year}    2
    ${remarks}=    Get Selected List Label    id=remarks
    Should Be Equal    ${remarks}    Old
    Click Element   id=savebutton
    Check Status OK
    Wait Until Element Is Visible    xpath=//table[@id='students']    timeout=10s
    ${rows}=    Get WebElements    xpath=//table[@id='students']//tr
    FOR    ${row}    IN    @{rows}
        ${row_text}=    Get Text    ${row}
        IF    '${row_text}' == '33928124'
            Should Contain    ${row_text}    33928124
            Should Contain    ${row_text}    Jonathan
            Should Not Contain    ${row_text}    John
        END
    END

Delete Student Entry
    Sleep    1
    Initialize Student Dropdown
    Wait Until Element Is Visible    id=StudentDelete    timeout=10s
    Click Element    id=StudentDelete
    Check Status OK
    Wait Until Element Is Visible    id=idnumber1    timeout=10s
    Input Text    id=idnumber1    33928124
    Click Element    id=searchbutton
    Wait Until Element Is Visible    id=deletebutton    timeout=10s
    Click Element    id=deletebutton
    Check Status OK
    ${table_text}=    Get Text    xpath=//table[@id='students']
    Should Not Contain    ${table_text}    33928124

Verify Subject Dropdowns
    Sleep    1
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectEntry    timeout=10s
    Click Element    id=SubjectEntry
    Check Status OK
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectList   timeout=10s
    Click Element    id=SubjectList
    Check Status OK
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectEdit    timeout=10s
    Click Element    id=SubjectEdit
    Check Status OK
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectDelete    timeout=10s
    Click Element    id=SubjectDelete
    Check Status OK

Add Subject Entry
    Sleep    1
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectEntry    timeout=10s
    Click Element    id=SubjectEntry
    Check Status OK
    # Case 1: Add a dummy entry and check if cancel works
    Input Text    id=subjectcode    123
    Input Text    id=description    123
    Input Text    id=units    1
    FOR    ${index}    IN RANGE    3
        Select From List By Index    id=offering    ${index}
    END
    FOR    ${index}    IN RANGE    2
        Select From List By Index    id=category    ${index}
    END
    FOR    ${index}    IN RANGE    3
        Select From List By Index    id=coursecode    ${index}
    END
    Input Text    id=curriculumyear    123-123
    Input Text    id=requisite    123
    Click Element    id=cancel
    ${subjectcode}=    Get Value    id=subjectcode
    Should Be Empty    ${subjectcode}
    ${description}=    Get Value    id=description
    Should Be Empty    ${description}
    ${units}=    Get Value    id=units
    Should Be Empty    ${units}
    ${curriculumyear}=    Get Value    id=curriculumyear
    Should Be Empty    ${curriculumyear}
    ${requisite}=    Get Value    id=requisite
    Should Be Empty    ${requisite}
    Check Status OK
    # Case 2: Add a dummy entry without requisite and check if submit works
    Input Text    id=subjectcode    TESTING100
    Input Text    id=description    Testing Subject
    Input Text    id=units    3
    Select From List By Index    id=offering    0
    Select From List By Index    id=category    1
    Select From List By Index    id=coursecode    1
    Input Text    id=curriculumyear    2024-2025
    ${subjectcode}=    Get Value    id=subjectcode
    Should Be Equal    ${subjectcode}    TESTING100
    ${description}=    Get Value    id=description
    Should Be Equal    ${description}    Testing Subject
    ${units}=    Get Value    id=units
    Should Be Equal    ${units}    3
    ${offering}=    Get Selected List Label    id=offering
    Should Be Equal    ${offering}    First Semester
    ${category}=    Get Selected List Label    id=category
    Should Be Equal    ${category}    Laboratory
    ${coursecode}=    Get Selected List Label    id=coursecode
    Should Be Equal    ${coursecode}    BSIS
    ${curriculumyear}=    Get Value    id=curriculumyear
    Should Be Equal    ${curriculumyear}    2024-2025
    ${requisite}=    Get Value    id=requisite
    Should Be Empty    ${requisite}
    Sleep    1
    Click Element    id=save
    Check Status OK
    # Case 3: Add a dummy entry with requisite and check if submit works
    Input Text    id=subjectcode    TESTING101
    Input Text    id=description    Testing Subject 2
    Input Text    id=units    3
    Select From List By Index    id=offering    1
    Select From List By Index    id=category    1
    Select From List By Index    id=coursecode    1
    Input Text    id=curriculumyear    2024-2025
    Input Text    id=requisite    TESTING100
    ${subjectcode}=    Get Value    id=subjectcode
    Should Be Equal    ${subjectcode}    TESTING101
    ${description}=    Get Value    id=description
    Should Be Equal    ${description}    Testing Subject 2
    ${units}=    Get Value    id=units
    Should Be Equal    ${units}    3
    ${offering}=    Get Selected List Label    id=offering
    Should Be Equal    ${offering}    Second Semester
    ${category}=    Get Selected List Label    id=category
    Should Be Equal    ${category}    Laboratory
    ${coursecode}=    Get Selected List Label    id=coursecode    
    Should Be Equal    ${coursecode}    BSIS
    ${curriculumyear}=    Get Value    id=curriculumyear
    Should Be Equal    ${curriculumyear}    2024-2025
    ${requisite}=    Get Value    id=requisite
    Should Be Equal    ${requisite}    TESTING100
    Scroll Element Into View    id=save
    Click Element    id=save
    Check Status OK

Verify Added Entry in Subject List
    Sleep    1
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectList    timeout=10s
    Click Element    id=SubjectList
    Check Status OK
    ${table_text}=    Get Text    xpath=//table[@id='subjects']//td[contains(text(), 'TESTING100')]
    Should Contain    ${table_text}    TESTING100
    ${table_text}=    Get Text    xpath=//table[@id='subjects']//td[contains(text(), 'TESTING101')]
    Should Contain    ${table_text}    TESTING101

Edit Subject Entry
    Sleep    1
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectEdit    timeout=10s
    Click Element    id=SubjectEdit
    Check Status OK
    Wait Until Element Is Visible    id=subjectcode    timeout=10s
    Input Text    id=subjectcode    TESTING100
    Input Text    id=coursecode    BSIS
    Click Element    id=searchbutton
    # Case 1: Edit the Subject Code to another value
    Input Text    id=subjectcode2    TESTING200
    Click Element    id=savebutton
    Check Status OK
    ${table_text}=    Get Text    xpath=//table[@id='subjects']//td[contains(text(), 'TESTING200')]
    Should Contain    ${table_text}    TESTING200
    # Case 2: Edit the Subject Code back to the original value
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectEdit    timeout=10s
    Click Element    id=SubjectEdit
    Check Status OK
    Wait Until Element Is Visible    id=subjectcode    timeout=10s
    Input Text    id=subjectcode    TESTING200
    Input Text    id=coursecode    BSIS
    Click Element    id=searchbutton
    Input Text    id=subjectcode2    TESTING100
    Click Element    id=savebutton
    Check Status OK
    ${table_text}=    Get Text    xpath=//table[@id='subjects']//td[contains(text(), 'TESTING100')]
    Should Contain    ${table_text}    TESTING100
    # Case 3: Edit the details to another value
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectEdit    timeout=10s
    Click Element    id=SubjectEdit
    Check Status OK
    Wait Until Element Is Visible    id=subjectcode    timeout=10s
    Input Text    id=subjectcode    TESTING100
    Input Text    id=coursecode    BSIS
    Click Element    id=searchbutton
    Wait Until Element Is Visible    id=description    timeout=10s
    Input Text    id=description    Testing Subject 3
    Input Text    id=units    4
    Select From List By Index    id=offering    2
    Select From List By Index    id=category    0
    Select From List By Index    id=coursecode    0
    Input Text    id=curriculumyear    2025-2026
    ${subjectcode}=    Get Value    id=subjectcode2
    Should Be Equal    ${subjectcode}    TESTING100
    ${description}=    Get Value    id=description
    Should Be Equal    ${description}    Testing Subject 3
    ${units}=    Get Value    id=units
    Should Be Equal    ${units}    4
    ${offering}=    Get Selected List Label    id=offering
    Should Be Equal    ${offering}    Summer
    ${category}=    Get Selected List Label    id=category
    Should Be Equal    ${category}    Lecture
    ${coursecode}=    Get Selected List Label    id=coursecode
    Should Be Equal    ${coursecode}    BSIT
    ${curriculumyear}=    Get Value    id=curriculumyear
    Should Be Equal    ${curriculumyear}    2025-2026
    Click Element   id=savebutton
    Check Status OK
    Wait Until Element Is Visible    xpath=//table[@id='subjects']    timeout=10s
    ${rows}=    Get WebElements    xpath=//table[@id='subjects']//tr
    FOR    ${row}    IN    @{rows}
        ${row_text}=    Get Text    ${row}
        IF    '${row_text}' == 'TESTING100'
            Should Contain    ${row_text}    TESTING100
            Should Contain    ${row_text}    Testing Subject 3
            Should Not Contain    ${row_text}    Testing Subject
        END
    END

Delete Subject Entry
    Sleep    1
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectDelete    timeout=10s
    Click Element    id=SubjectDelete
    Check Status OK
    Wait Until Element Is Visible    id=subjectcode    timeout=10s
    Input Text    id=subjectcode    TESTING100
    Input Text    id=coursecode    BSIT
    Click Element    id=searchbutton
    Wait Until Element Is Visible    id=deletebutton    timeout=10s
    Click Element    id=deletebutton
    Check Status OK
    Initialize Subject Dropdown
    Wait Until Element Is Visible    id=SubjectDelete    timeout=10s
    Click Element    id=SubjectDelete
    Check Status OK
    Wait Until Element Is Visible    id=subjectcode    timeout=10s
    Input Text    id=subjectcode    TESTING101
    Input Text    id=coursecode    BSIS
    Click Element    id=searchbutton
    Wait Until Element Is Visible    id=deletebutton    timeout=10s
    Click Element    id=deletebutton
    Check Status OK
    ${table_text}=    Get Text    xpath=//table[@id='subjects']
    Should Not Contain    ${table_text}    TESTING101

