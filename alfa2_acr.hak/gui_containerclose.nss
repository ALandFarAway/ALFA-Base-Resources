void main()
{
	if (GetLocalObject(OBJECT_SELF, "ACR_PCHEST_OPENED")) {
		PlayAnimation(ANIMATION_PLACEABLE_CLOSE);
		DeleteLocalObject(OBJECT_SELF, "ACR_PCHEST_OPENED");
	}
}
