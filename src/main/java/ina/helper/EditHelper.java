package ina.helper;

import ina.objects.Stamp;
import ina.objects.StampsList;
import ina.objects.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class EditHelper extends HelperBase {
    public EditHelper(HttpServletRequest request, HttpServletResponse response) {
        super(request, response);
    }

    /**
     * Retrieves post parameters from content.jsp and edit.jsp
     * Pending of the parameters favorites will be un/set, stamps will be added, deleted or edited.
     *
     * @param request
     * @param response
     * @throws IOException
     */
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (request.getSession().getAttribute("editHelper") == null) {
            request.getSession().setAttribute("editHelper", this);
        }

        // Get user
        LoginHelper loginHelper = (LoginHelper) request.getSession().getAttribute("loginHelper");


        if(loginHelper == null || loginHelper.getUser() == null){
            // User has no session
            return;
        }

        User currentUser = loginHelper.getUser();

        // Get post parameters
        Map<String, String[]> parameters = request.getParameterMap();

        boolean redirectToEdit = false;
        for(Map.Entry<String, String[]> entry : parameters.entrySet()){
            switch (entry.getKey()){
                case "check":
                    for(String stampName : entry.getValue()){
                        if(StampsList.getStamps().stream().anyMatch(x -> x.getName().equals(stampName))){
                            if(currentUser.getFavoriteStamps().stream().noneMatch(x -> x.getName().equals(stampName))){
                                currentUser.addToFavorite(stampName);
                            }
                        }
                    }
                    break;
                case "uncheck":
                    for(String stampName : entry.getValue()){
                        // Uncheck a stamp as favorite
                        if(currentUser.getFavoriteStamps().stream().anyMatch(x -> x.getName().equals(stampName))) {
                            currentUser.removeFromFavorite(stampName);
                        }
                    }
                    break;
                case "addStamp":
                    for(String stamp : entry.getValue()){
                        String[] stampValues = stamp.split("\\|");

                        // If stamp already exists - edit - checks if an ID was set = stamp already exists, because an ID is set when a stamp is added to "database"
                        boolean exists = isNumeric(stampValues[0].substring(1));

                        Stamp updateStamp = createNewStamp(stampValues);
                        if (exists) {
                            // Edit
                            StampsList.editStamp(updateStamp);
                        } else {
                            // Create new
                            StampsList.addStamp(updateStamp);
                        }
                    }
                    redirectToEdit = true;
                    break;
                case "deleteStamp":
                    for(String stamp : entry.getValue()){
                        String[] stampValues = stamp.split("\\|");

                        // stampValues[0] gives #stampID -> Remove the '#'
                        if(isNumeric(stampValues[0].substring(1))){
                            StampsList.deleteStamp(Integer.parseInt(stampValues[0].substring(1)));
                        }
                    }
                    redirectToEdit = true;
                    break;
                default:
                    break;
            }
        }
        if(redirectToEdit){
            response.sendRedirect("edit.jsp");
        }
    }

    /**
     * Creates a new stamp with the given values and validates those values
     *
     * @param stampValues as new stamp values
     * @return created stamp
     */
    private Stamp createNewStamp(String[] stampValues){
        Integer stampID = stampValues.length >= 1 && stampValues[0] != null && isNumeric(stampValues[0].substring(1)) ? Integer.parseInt(stampValues[0].substring(1)) : null;
        String name = stampValues.length >= 2 && stampValues[1] != null ? stampValues[1] : "";
        Integer value = stampValues.length >= 3 && stampValues[2] != null && isNumeric(stampValues[2]) ? Integer.parseInt(stampValues[2]) : null;
        Integer quantity = stampValues.length >= 4 && stampValues[3] != null && isNumeric(stampValues[3]) ? Integer.parseInt(stampValues[3]) : null;
        String[] date_country = stampValues.length >= 5 && stampValues[4] != null ? stampValues[4].split(" ") : new String[]{};
        String pubDate = date_country.length >= 1 && stampValues[0] != null ? date_country[0] : "";
        String pubCountry = date_country.length >= 2 && stampValues[1] != null ? date_country[1] : "";
        String motif = stampValues.length >= 6 && stampValues[5] != null ? stampValues[5] : "";

        if(name.isBlank()){
            System.out.println("Wrong input for stamp values");
            // TODO: Print error messages
            return null;
        }

        Stamp newStamp = new Stamp(name, value, quantity);
        newStamp.setStampID(stampID);
        newStamp.setPublishedDate(pubDate);
        newStamp.setPublishedCountry(pubCountry);
        newStamp.setMotif(motif);

        return newStamp;
    }

    /**
     * Checks wether a String is a number
     *
     * @param x as String
     * @return is number numeric
     */
    public static boolean isNumeric(String x) {
        if (x == null) {
            return false;
        }
        try {
            Integer.parseInt(x);
        } catch (NumberFormatException nfe) {
            return false;
        }
        return true;
    }
}
