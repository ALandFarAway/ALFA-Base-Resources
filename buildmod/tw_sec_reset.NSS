/* User-defined event script to reset a secret item after a delay of
 * 20 seconds.
 */

#include "tw_secret"

void main()
{
    if (GetUserDefinedEventNumber() == EVENT_SECRET_REVEALED) {
        DelayCommand(20.0, ResetSecretItem());
    }
}