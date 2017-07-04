package stylish.ejb;

import java.util.List;
import javax.ejb.Local;
import stylish.entity.CartLineInfo;
import stylish.entity.Orders;

@Local
public interface OrderStateFulBeanLocal {

    void addProduct(CartLineInfo cartLineInfo);

    boolean deleteProduct(CartLineInfo cartLineInfo);

    boolean updateProduct(CartLineInfo oldCartLineInfo, CartLineInfo cartLineInfo);

    List<CartLineInfo> showCart();

    CartLineInfo getProductInListByID(int productid, int sizeid, int colorid);

    String completePurchase(Orders orders);

    float subTotal();

}
