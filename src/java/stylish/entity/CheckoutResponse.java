package stylish.entity;

public class CheckoutResponse {

    private String status;
    private String showDiscount;
    private String showDiscountPercent;

    public CheckoutResponse() {
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getShowDiscount() {
        return showDiscount;
    }

    public void setShowDiscount(String showDiscount) {
        this.showDiscount = showDiscount;
    }

    public String getShowDiscountPercent() {
        return showDiscountPercent;
    }

    public void setShowDiscountPercent(String showDiscountPercent) {
        this.showDiscountPercent = showDiscountPercent;
    }
}
