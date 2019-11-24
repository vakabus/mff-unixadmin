/*
 * xstress - xk0derz SMTP Stress Tester
 *
 * (c) Amit Singh amit@xkoder.com
 * http://xkoder.com
 *
 * This software and related files are licensed under GNU GPL version 2
 * Please visit the following webpage for more details
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 */
#include <cstdlib>
#include <cstring>

#include "common.h"
#include "userinterface.h"
#include "config.h"

using namespace std;

const char *cmdOptStr[]=
{
  "  ",
  "-v",
  "--ver",
  "--version",
  "--help",
  "-h",
  "--threads",
  "-t",
  "-m",
  "--mails",
  "--server",
  "-s",
  "--port",
  "-p",
  "--timeout",
  "--conf",
  "--logfile",
  "--license",
  "-u",
  "--username",
  "-P",
  "--password",
  "-a",
  "--auth-type",
  "-d",
  "--debug",
  " "
};


void UserInterface::setConfig(Config &configObj)
{
  if(!sServerIP.empty()) configObj.sServerIP = sServerIP;
  if(!sLogFile.empty()) configObj.sLogFile = sLogFile;
  
  if(uiThreads>0) configObj.uiThreads = uiThreads;
  if(uiMailsPerThread>=0) configObj.uiMailsPerThread = uiMailsPerThread;
  if(uiTimeout>0) configObj.uiTimeout = uiTimeout;
  if(uiServerPort>0) configObj.uiServerPort = uiServerPort;
  
  if(!sUsername.empty()) configObj.sUsername = sUsername;
  if(!sPassword.empty()) configObj.sPassword = sPassword;
  
  if(!sAuthType.empty()) configObj.sAuthType = sAuthType;

}

unsigned int UserInterface::override()
{
  return uiOverride;
}

UserInterface::UserInterface()
{
  uiServerPort = -1;
  uiThreads = -1;
  uiMailsPerThread = -1;
  uiTimeout = -1;
  sServerIP = "";
  sLogFile = "";
  sUsername = "";
  sPassword = "";
  sAuthType = "";

  sConfigFile = DEFAULT_CONFIG_FILE;  
  uiOverride = false;
}

int UserInterface::processOptions(int argc, const char *argv[])
{
  string sOpt, sVal;
  int iRetVal = true, ii, jj;
  int iOpt;
  if(argc<2) return iRetVal;

  for(ii=1;ii<argc;ii++)
  {
    sOpt = argv[ii];
    iOpt = CO_NONE;
    for(jj = 1; jj < CO_MAX; jj++)
    {
      if(sOpt == cmdOptStr[jj])
      {
        iOpt = jj;
        break;
      }
    }
    
    switch(iOpt)
    {
      case CO_D:
      case CO_DEBUG:
            bDebug = true;
        break;

      case CO_A:
      case CO_AUTH_TYPE:
            if(ii<(argc-1))
            {
              ii++;
              sAuthType = argv[ii];
              char cBuf[255];
              if(sAuthType.length() < 200)
              {
                  strcpy(cBuf, sAuthType.c_str());
                  int jj = 0;
                  while(cBuf[jj])
                  {
                      cBuf[jj] = toupper(cBuf[jj]);
                      jj++;
                  }
                  sAuthType = cBuf;
              }
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_BIG_P:
      case CO_PASSWORD:
            if(ii<(argc-1))
            {
              ii++;
              sPassword = argv[ii];
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_U:
      case CO_USERNAME:
            if(ii<(argc-1))
            {
              ii++;
              sUsername = argv[ii];
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_V:
      case CO_VER:
      case CO_VERSION:
            cout << VERSION << endl;
            cout << COPYRIGHT << endl;
            iRetVal = false;
            break;
      case CO_HELP:
      case CO_H:
            cout << VERSION << endl;
            cout << COPYRIGHT << endl;
            cout << endl;
            cout << HELP_MSG << endl;
            iRetVal = false;
            break;
      case CO_THREADS:
      case CO_T:
            if(ii<(argc-1))
            {
              ii++;
              uiThreads = atoi(argv[ii]);
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_M:
      case CO_MAILS_PER_THREADS:
            if(ii<(argc-1))
            {
              ii++;
              uiMailsPerThread = atoi(argv[ii]);
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_SERVER:
      case CO_S:
            if(ii<(argc-1))
            {
              ii++;
              sServerIP = argv[ii];
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_PORT:
      case CO_P:
            if(ii<(argc-1))
            {
              ii++;
              uiServerPort = atoi(argv[ii]);
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_TIMEOUT:
            if(ii<argc)
            {
              ii++;
              uiTimeout = atoi(argv[ii]);
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_CONF:
            if(ii<(argc-1))
            {
              ii++;
              sConfigFile = argv[ii];
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_LOGFILE:
            if(ii<(argc-1))
            {
              ii++;
              sLogFile = argv[ii];
              uiOverride = true;
            }
            else
            {
              cout << "Option " << argv[ii] << " requires a value" << endl;
              iRetVal = false;
            }
            break;
      case CO_LICENSE:
            {

              cout << VERSION << endl;
              cout << COPYRIGHT << endl << endl;

              cout << "This program is free software; you can redistribute it and/or" <<endl;
              cout << "modify it under the terms of the GNU General";
              cout << " Public License version 2" << endl;
              cout << "as published by the Free Software Foundation."<< endl;
              cout << endl;
              cout << "This program is distributed in the hope that it will be useful," << endl;
              cout << "but WITHOUT ANY WARRANTY; without even the implied warranty of" << endl;
              cout << "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" << endl;
              cout << "GNU General Public License for more details." << endl;
              cout << endl;
              cout << "You should have received a copy of the GNU General Public License" << endl;
              cout << "along with this program; if not, write to the Free Software" << endl;
              cout << "Foundation, Inc., 51 Franklin Street, Fifth Floor,";
              cout << " Boston, MA  02110-1301, USA." << endl;
              cout << endl;
              cout << "You may contact the author at amit@xkoder.com" << endl;

              iRetVal = false;

            }
          break;
    }
  }
  return iRetVal;
}
