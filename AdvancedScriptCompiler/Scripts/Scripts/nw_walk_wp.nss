// ChazM 1/6/06 modified to work with scripted waypoints
#include "NW_I0_GENERIC"

void main()
{
	// Calling WalkWayPoints() does nothing at all since we are still in conversation
	// mode when this is called.
    // WalkWayPoints();

	// the default conversation file changed to mark it so that the delay will be skipped
    DelayCommand(1.0, WalkWayPoints(TRUE, "nw_walk_way"));
}