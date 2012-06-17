
void main(int SourceServerID, string Argument)
{
	WriteTimestampedLogEntry("acr_ipc_logmsg: " + IntToString(SourceServerID) + " - " + Argument);
}

