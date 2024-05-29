*** Settings ***
Documentation       Sending plain text email via gmail

Library             RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587
Library             DOP.RPA.ProcessArgument
Library             Collections
Library             DOP.RPA.Log
Library             DOP.RPA.Asset
Library             OperatingSystem
Library             RPA.Excel.Files
Library             String
Library             ConvertStringToPrice
Library             RPA.JSON

*** Tasks ***
Send Errors Or Issue Notifacation
    [Documentation]    Send Errors Or Issue Notifacation

    ${gmail_account_credentials}=    Get Asset    gmail_account
    ${gmail_account_credentials}=    Set Variable    ${gmail_account_credentials}[value]
    ${gmail_account_credentials}=    Convert String to JSON    ${gmail_account_credentials}
    ${username}=    Set Variable    ${gmail_account_credentials}[username]
    ${password}=    Set Variable    ${gmail_account_credentials}[password]

    Authorize    account=${username}    password=${password}

    ${recipients}=    Get In Arg    recipients_email_address
    ${recipients_value}=    Set Variable    ${recipients}[value]
    ${recipient_value_list}=    Split String    ${recipients_value}    ,
    @{list_recipient}=    Create List    
    FOR    ${recipient}    IN    @{recipient_value_list}
        Append To List    ${list_recipient}    ${recipient}
    END

    ${url_file_text}=    Get In Arg    content_errors
    ${url_file_text_value}=    Set Variable    ${url_file_text}[value]
    ${content_errors}=    Get File    ${url_file_text_value}

    Create File    ${url_file_text_value}    ${content_errors}

    RPA.Email.ImapSmtp.Send Message    sender=${username}
    ...    recipients=${list_recipient}
    ...    subject=Send Result Report Via Email By Infomation Of Product Magento
    ...    body=${content_errors}
