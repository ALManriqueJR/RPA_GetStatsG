*** Settings ***
Documentation   Robo para capturar dados de ataques das espadas de Genshin Impact
Library     Browser
Library     Collections
Library     RPA.Excel.Files

*** Variables ***

*** Tasks ***
Exportando dados de itens do Genshin para o Excel
    Dado que eu esteja no Honey Hunter
    Quando clicar na categoria Swords
    Entao trazer os campos de nome e ataque para um dicionario
    Entao exportar para uma planilha Excel os dados

*** Keywords ***
Dado que eu esteja no Honey Hunter
    New Browser                headless=false       #slowMo=2
    New Page                   https://genshin.honeyhunterworld.com/?lang=EN

Quando clicar na categoria Swords
    Click    //*[@id="ncmp__tool"]/div/div/div[3]/div[1]/button[2]  #Cookies Google pop up
    Click    //*[@for='1609326270']                                 #/html/body/div[1]/div[2]/div[1]/label[2]
    Click    //*[@for='1937977254']                                  #/html/body/div[1]/div[2]/div[1]/div[2]/a[1]
    Select Options By    //*[@id="weapons"]/table/tbody/tr/td[1]/select    text     100

Entao trazer os campos de nome e ataque para um dicionario
    Sleep    2
    ${LIST_ITEMS}   Create List
    ${table_rows}    Get Element Count    //*[@class='genshin_table sortable weapon_table']/tbody/tr

    FOR    ${counter}    IN RANGE   1    ${table_rows+1}
        ${nome}     Get Text    //*[@class='genshin_table sortable weapon_table']/tbody/tr[${counter}]/td[2]/a
        ${atk}     Get Text    //*[@class='genshin_table sortable weapon_table']/tbody/tr[${counter}]/td[4]
        ${sword_atk}    Create Dictionary    nome = '${nome}'     atk = '${atk}'
        Append To List    ${LIST_ITEMS}     ${sword_atk}
    END

    Set Global Variable    ${LIST_ITEMS}

Entao exportar para uma planilha Excel os dados
    Create Workbook
    Append Rows To Worksheet   content=${LIST_ITEMS}
    Save Workbook    SwordAtkStats.xlsx
