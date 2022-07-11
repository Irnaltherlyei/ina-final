package ina.objects;

import java.text.DecimalFormat;
import java.util.HashSet;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Static class representing a database table
 */
public class StampsList {
    private static final HashSet<Stamp> stamps = new HashSet<>();

    /**
     * AtomicInteger auto increments representing an ID
     */
    private static final AtomicInteger stampID = new AtomicInteger(100);

    // Filling the database table with some stamps
    static {
        // https://www.bezahlen.net/ratgeber/teuerste-briefmarke-der-welt/#:~:text=Die%20teuersten%20Briefmarken%20im%20%C3%9Cberblick%20%20%20,sein%20m%20...%20%206%20more%20rows%20

        // 1. Briefmarke
        Stamp stamp = new Stamp("British Giuna 1c Magenta", 9000000, 1);
        stamp.setPublishedCountry("Guyana");
        stamp.setPublishedDate("1856");
        stamp.setMotif("Sailing ship with quote in latin");
        addStamp(stamp);

        // 2. Briefmarke
        stamp = new Stamp("The Treskilling Yellow", 2100000, 1);
        stamp.setPublishedCountry("Sweden");
        stamp.setPublishedDate("1855");
        stamp.setMotif("National coat of arms of sweden showing their three crows");
        addStamp(stamp);

        // 3. Briefmarke
        stamp = new Stamp("The blue Mauritius and the red Mauritius", 1100000, 26);
        stamp.setPublishedCountry("Mauritius");
        stamp.setPublishedDate("1847");
        stamp.setMotif("Queen Victoria on either blue or red canvas");
        addStamp(stamp);

        // 4. Briefmarke
        stamp = new Stamp("Baden 9 Kreuzer", 1000000, 4);
        stamp.setPublishedCountry("Germany");
        stamp.setPublishedDate("1851");
        stamp.setMotif("Green colored");
        addStamp(stamp);

        // 5. Briefmarke
        stamp = new Stamp("Inverted Jenny", 750000, 100);
        stamp.setPublishedCountry("USA");
        stamp.setPublishedDate("1918");
        stamp.setMotif("Flipped airplane Curtiss JN-4");
        addStamp(stamp);
    }

    /**
     * Adding a new stamp to the "database" table and auto incrementing the ID
     *
     * @param stamp to add
     * @return success
     */
    public static boolean addStamp(Stamp stamp){
        if(stamp == null){
            return false;
        }

        stamp.setStampID(stampID.incrementAndGet());

        if(getStamp(stamp) == null){
            System.out.println("Added " + stamp.getName() + " to collection.");
            return stamps.add(stamp);
        }

        return false;
    }

    /**
     * Deleting a stamp from the "database" table
     *
     * @param stamp to delete
     * @return success
     */
    public static boolean deleteStamp(Stamp stamp){
        System.out.println("Removed " + stamp.getName() + " from collection.");
        return stamps.removeIf(x -> x.equals(stamp));
    }

    /**
     * Deleting a stamp with the given ID from the "database" table
     *
     * @param stampID to delete
     * @return success
     */
    public static boolean deleteStamp(Integer stampID){
        System.out.println("Removed stamp #" + stampID + " from collection.");
        return stamps.removeIf(x -> x.getStampID().equals(stampID));
    }

    /**
     * Edits a stamp with the given stamp ID
     *
     * @param stamp with edited values
     */
    public static void editStamp(Stamp stamp){
        Stamp editStamp = getStamp(stamp);

        if(editStamp == null){
            return;
        }

        System.out.println("Updated " + stamp.getName() + " in collection.");

        editStamp.setName(stamp.getName());
        editStamp.setValue(stamp.getValue());
        editStamp.setQuantity(stamp.getQuantity());
        editStamp.setPublishedDate(stamp.getPublishedDate());
        editStamp.setPublishedCountry(stamp.getPublishedCountry());
        editStamp.setMotif(stamp.getMotif());
    }

    public static Stamp getStamp(Stamp stamp){
        return stamps.stream().filter(s -> s.equals(stamp)).findFirst().orElse(null);
    }

    public static Integer getSummedValue(){
        return stamps.stream().mapToInt(Stamp::getSummedValue).sum();
    }

    public static HashSet<Stamp> getStamps() {
        return stamps;
    }

    /**
     * Formats a given Number to either million "m"
     * or thousand "k"
     * e.G. 1,200,000 to 1.2m
     *
     * @param value as Number
     * @return Number as String
     */
    public static String formatNumber(Integer value) {
        Float x = 0f;
        DecimalFormat df = new DecimalFormat();
        if(value >= 1000){
            x = value / 1000f;
            df = new DecimalFormat("###,###,###.###k");
        }
        if (value >= 1000000){
            x = value / 1000000f;
            df = new DecimalFormat("###,###,###.###m");
        }
        return df.format(x);
    }
}
