/* GESTURE SCRIPT - PC performs gesture and voicechat GOODBYE */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_GOODBYE, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_SALUTE));
}

