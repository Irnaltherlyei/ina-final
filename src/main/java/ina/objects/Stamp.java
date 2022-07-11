package ina.objects;

public class Stamp {
    private String name;
    private Integer value;
    private Integer quantity;

    private Integer stampID;

    private String publishedCountry;
    private String publishedDate;
    private String motif;

    /**
     * Class representing a Stamp
     *
     * @param name as Name
     * @param value as Value
     * @param quantity as Quantity
     */
    public Stamp(String name, Integer value, Integer quantity) {
        this.name = name;
        this.value = value;
        this.quantity = quantity;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getStampID() {
        return stampID;
    }

    public void setStampID(Integer stampID) {
        this.stampID = stampID;
    }

    public String getPublishedCountry() {
        return publishedCountry;
    }

    public void setPublishedCountry(String publishedCountry) {
        this.publishedCountry = publishedCountry;
    }

    public String getPublishedDate() {
        return publishedDate;
    }

    public void setPublishedDate(String publishedDate) {
        this.publishedDate = publishedDate;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Stamp)) return false;

        Stamp stamp = (Stamp) o;

        return stampID.equals(stamp.stampID);
    }

    @Override
    public String toString() {
        return "Stamp:" +
                " " + stampID +
                " " + name + '\'' +
                ", Price = " + value +
                ", Quantity = " + quantity +
                ", Manufactured: '" + publishedDate + " " + publishedCountry + '\'' +
                " " + motif + '\'';
    }

    /**
     * Summed value
     *
     * @return quantity * value
     */
    public Integer getSummedValue(){
        return (quantity != null ? quantity : 0) * (value != null ? value : 0);
    }
}
