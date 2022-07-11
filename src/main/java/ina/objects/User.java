package ina.objects;

import java.util.HashSet;

public class User {
    private String username;
    private String password;
    private boolean isAdmin;

    private HashSet<Stamp> favoriteStamps = new HashSet<>();

    /**
     * Class representing a User
     *
     * @param username as name
     * @param password as password
     */
    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    public HashSet<Stamp> getFavoriteStamps() {
        for (Stamp stamp : favoriteStamps){
            boolean stillExists = StampsList.getStamps().stream().anyMatch(x -> x.getStampID().equals(stamp.getStampID()));
            if(!stillExists){
                System.out.println("Removed " + stamp.getName() + " from favorites, because it got deleted");
                removeFromFavorite(stamp);
            }
        }

        return favoriteStamps;
    }

    public void setFavoriteStamps(HashSet<Stamp> favoriteStamps) {
        this.favoriteStamps = favoriteStamps;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof User)) return false;

        User user = (User) o;

        if (!username.equals(user.username)) return false;
        return password.equals(user.password);
    }

    @Override
    public String toString() {
        return username;
    }

    /**
     * Validates the username and the password of the user
     *
     * @return validation
     */
    public boolean isValid(){
        if(username.length() <= 0){
            return false;
        }
        return password.length() > 0;
    }

    public void addToFavorite(Stamp stamp){
        favoriteStamps.add(stamp);
    }

    public void addToFavorite(String stampName){
        System.out.println("Added " + stampName + " to favorites.");
        StampsList.getStamps().stream().filter(x -> stampName.equals(x.getName())).findFirst().ifPresent(stamp -> favoriteStamps.add(stamp));
    }

    public void removeFromFavorite(Stamp stamp){
        favoriteStamps.remove(stamp);
    }

    public void removeFromFavorite(String stampName){
        System.out.println("Removed " + stampName + " from favorites.");
        favoriteStamps.stream().filter(x -> stampName.equals(x.getName())).findFirst().ifPresent(stamp -> favoriteStamps.remove(stamp));
    }
}
