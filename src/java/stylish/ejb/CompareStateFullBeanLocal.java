package stylish.ejb;

import java.util.List;
import javax.ejb.Local;
import stylish.entity.Products;

@Local
public interface CompareStateFullBeanLocal {

    boolean addProduct(Products product);

    boolean deleteItem(int productID);
    
    boolean deleteAll();

    List<Products> showCompare();

    public Products getProductInListByID(int productID);
}
