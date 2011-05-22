//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_runnningalarm
//::
//::	A "Call for reinforcements" guy, this creature will run for help and use silent shouts to attract help.
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 1/30/06

#include "ginc_ai"
	

void main()
{

		//You don't need to change anything here. There is no configuration, this command will make a guy a runnningalarm.


		AIAssignDCR(OBJECT_SELF,SCRIPT_RUNNING_ALARM_DCR);

}