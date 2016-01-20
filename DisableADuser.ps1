$Account = read-host "Enter the login name of the account:";
$PathAccount = dsquery * -filter "&(objectcategory=user)(sAMAccountName=$Account)";
IF ($PathAccount -ne $NULL) {
$AccountName = dsquery * -filter "&(objectcategory=user)(sAMAccountName=$Account)" -attr givenName -l;
$AccountSName = dsquery * -filter "&(objectcategory=user)(sAMAccountName=$Account)" -attr sn -l;
$AccountTitle = dsquery * -filter "&(objectcategory=user)(sAMAccountName=$Account)" -attr title -l;
$AccountDepartment = dsquery * -filter "&(objectcategory=user)(sAMAccountName=$Account)" -attr department -l;
$AccountCompany = dsquery * -filter "&(objectcategory=user)(sAMAccountName=$Account)" -attr company -l;
$AccountTel = dsquery * -filter "&(objectcategory=user)(sAMAccountName=$Account)" -attr telephoneNumber -l;
$DisabledDate = Get-Date -format d;
dsmod user $PathAccount -desc $DisabledDate -disabled yes -company '""';
$dt = get-date -format 'MMM-yyyy';
md \\file-server\blocked\$dt\$Account;
Set-Mailbox -HiddenFromAddressListsEnabled $true -Identity "$Account";
New-MailboxExportRequest -Mailbox "$Account" -FilePath \\file-server\blocked\$dt\$Account\$Account.pst;
$enc = New-Object System.Text.utf8encoding
Send-MailMessage -From "System Engineer <administrator@domain.ru>" -To "hr@domain.ru", "it_team@domain.ru" -Encoding $enc -Subject "Пользователь $Account был заблокирован" -BodyAsHtml "Логин: <b>$Account</b><br />Сотрудник: <b>$AccountName $AccountSName</b><br />Телефон: <b>$AccountTel</b><br />Должность: <b>$AccountTitle</b><br />Департамент: <b>$AccountDepartment</b><br />Компания: <b>$AccountCompany</b><br /><hr />Это сообщение создано автоматически. Просьба не отвечать на него." -Priority High -SmtpServer <IP address>;
} ELSE {
echo "Пользователь с таким логином не опознан!"
}
