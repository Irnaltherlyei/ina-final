package ina.objects;

import java.util.HashSet;

/**
 * Static class representing a database table
 */
public class UsersList {
    private static final HashSet<User> users = new HashSet<>();

    // Filling the database table with two users
    static {
        // Hard coded users
        User user1 = new User("user1", "pw1");
        user1.setAdmin(true);
        users.add(user1);

        users.add(new User("user2", "pw2"));
    }

    public static void addUser(User user){
        users.add(user);
    }

    public static void removeUser(User user){
        users.remove(user);
    }

    public static HashSet<User> getUsers(){
        return users;
    }
}
