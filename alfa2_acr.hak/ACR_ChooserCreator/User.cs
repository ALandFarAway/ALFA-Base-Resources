using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ChooserCreator
{
    public static class Users
    {
        public static Dictionary<uint, User> TrackedUsers = new Dictionary<uint, User>();

        public static User GetUser(uint userId)
        {
            if(TrackedUsers.Keys.Contains(userId))
            {
                return TrackedUsers[userId];
            }
            else
            {
                User newUser = new User()
                {
                    Id = userId,
                    CurrentCreatureCategory = Navigators.CreatureNavigator.bottomCategory,
                    CurrentItemCategory = Navigators.ItemNavigator.bottomCategory,
                    CurrentPlaceableCategory = Navigators.PlaceableNavigator.bottomCategory
                };
                TrackedUsers.Add(userId, newUser);
                return newUser;
            }
        }
    }
    public class User
    {
        public uint Id;
        public ACR_ChooserCreator.ACR_CreatorCommand openCommand;
        public NavigatorCategory CurrentCreatureCategory;
        public NavigatorCategory CurrentPlaceableCategory;
        public NavigatorCategory CurrentItemCategory;
    }
}
