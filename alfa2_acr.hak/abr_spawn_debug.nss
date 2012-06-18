
#include "acr_spawn_i"
#include "acr_debug_i"

void main() {

  int nReportTargets = ACR_GetDebuggingInfoTargets(_SPAWN_SYSTEM_NAME);
  if (nReportTargets & DEBUG_TARGET_DMS) {
    // Debug info is going to DM channel, redirect it to logs.
    ACR_SetDebuggingInfoTargets(_SPAWN_SYSTEM_NAME, DEBUG_TARGET_LOG);
    SendMessageToAllDMs("Deactivated DM-channel spawn system info reporting, redirected to server log.");
  } else if (nReportTargets & DEBUG_TARGET_LOG) {
    // Debug info has already been switched to log only, re-enable it for the DM channel.
    ACR_SetDebuggingInfoTargets(_SPAWN_SYSTEM_NAME, DEBUG_TARGET_DMS | DEBUG_TARGET_LOG);
    SendMessageToAllDMs("Activated DM-channel spawn system info reporting.");    
  }
}

