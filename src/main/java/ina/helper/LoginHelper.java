package ina.helper;

import ina.objects.Stamp;
import ina.objects.StampsList;
import ina.objects.User;
import ina.objects.UsersList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashSet;

public class LoginHelper extends HelperBase {
    // Set users as replacement for database use
    private final HashSet<User> users = UsersList.getUsers();
    // Set stamps as replacement for database use
    private final HashSet<Stamp> stamps = StampsList.getStamps();

    // Current user in session
    private User user;

    // Status messages
    private String unmatchedUser = "";
    private String status = "";

    public LoginHelper(HttpServletRequest request, HttpServletResponse response) {
        super(request, response);
    }

    /**
     * Simply checks if the user exists. If not create one. If the user exists check if the given password matches.
     * For any errors display a status messages.
     *
     * @param request as request
     * @param response as response
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        if (request.getSession().getAttribute("loginHelper") == null) {
            request.getSession().setAttribute("loginHelper", this);
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null) {
            status = "Please enter your credentials.";
            return;
        }

        User checkUser = null;

        // Access "database"
        User currentUser =  new User(username, password);
        for (User u : users) {
            if(u.getUsername().equals(currentUser.getUsername())){
                checkUser = u;
            }
        }

        if(checkUser == null){
            // User doesn't exist - create new user if valid
            if(!currentUser.isValid()){
                user = null;

                unmatchedUser = currentUser.getUsername();
                status =  "Username and password must have at least one character.";
                return;
            }

            users.add(currentUser);
            user = currentUser;
            System.out.println("Created user: " + currentUser.getUsername());
            return;
        }

        if(checkUser.getPassword().equals(currentUser.getPassword())){
            // Login
            user = checkUser;
            System.out.println("User in session: " + user.getUsername());
        } else {
            // Wrong password
            user = null;

            unmatchedUser = currentUser.getUsername();
            status ="Login credentials don't match.";
        }
    }

    public void setUser(User user) {
        this.user = user;
    }

    public User getUser() {
        return user;
    }

    public HashSet<Stamp> getStamps() {
        return stamps;
    }

    public String getStatus() {
        return status;
    }

    public String getUnmatchedUser() {
        return unmatchedUser;
    }
}
