var sBasePath = "D:\\ClearinghousePayers";
var sBinPath = sBasePath + "\\Bin";
var sSQLPath = sBasePath + "\\SQL";
var sScraper = sBinPath + "\\" + "ClearinghousePayerListScraper.exe";
var sSQLCMDScript = sSQLPath + "\\" + "RunMedAvantEligibilityScript.sql";
var sSQLCMDBinary = "sqlcmd";
//var aClearinghouses = new Array("MedAvant", "Gateway", "OfficeAlly" );
var aClearinghouses = new Array("MedAvant", "Gateway");
var sClearinghouse;

//run the scraper on each clearinghouse
eClearinghouses = new Enumerator(aClearinghouses);
for (;!eClearinghouses.atEnd();eClearinghouses.moveNext()) 
  runCommand(sScraper + " " + eClearinghouses.item());

//run the sqlcmd script to set the eligibility URLs
runCommand(sSQLCMDBinary + " -i " + sSQLCMDScript);

function runCommand(sCommand)
{

  WScript.Echo("-------------------------------------------------------------------");
  WScript.Echo("Running: " + sCommand);
  WScript.Echo("-------------------------------------------------------------------");

  var WshShell = new ActiveXObject("WScript.Shell");

  var oExec = WshShell.Exec(sCommand);


  while (true) //oExec.Status == 0)
  {
     if (!oExec.StdOut.AtEndOfStream)

     {

          WScript.StdOut.Write(oExec.StdOut.Read(100));

     }
     else
     {
       if (oExec.Status != 0)
         break;

       WScript.Sleep(100);
     }
  }

  WScript.Echo("-------------------------------------------------------------------");
  WScript.Echo("Returned: " + oExec.Status);
  WScript.Echo("-------------------------------------------------------------------");

}

