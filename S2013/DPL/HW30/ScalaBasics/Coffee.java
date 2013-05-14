
public class Coffee {
    private String name;

    public Coffee(String name_) {
        name = name_;
    }

    public void brew() {
        System.out.println("Brewing " + name + " coffee.");
    } 
}
