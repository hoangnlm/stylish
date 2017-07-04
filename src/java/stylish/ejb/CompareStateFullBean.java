package stylish.ejb;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.ejb.Stateful;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import stylish.entity.Products;

@Stateful
public class CompareStateFullBean implements CompareStateFullBeanLocal, Serializable {

    private static final long serialVersionUID = -1097584817553616545L;

    @EJB
    private OrderStateLessBeanLocal orderStateLessBean;
    @EJB
    private ProductStateLessBeanLocal productStateLessBean;

    @PersistenceContext
    private EntityManager em;

    public EntityManager getEntityManager() {
        return em;
    }

    private List<Products> list;

    @PostConstruct
    private void init() {
        list = new ArrayList<>();
    }

    @Override
    public boolean addProduct(Products product) {
        if (getProductInListByID(product.getProductID()) == null) {
            list.add(product);
            return true;
        }
        return false;
    }

    @Override
    public boolean deleteItem(int productID) {
        Products search = getProductInListByID(productID);
        if (search != null) {
            list.remove(search);
            return true;
        }
        return false;
    }

    @Override
    public boolean deleteAll() {
        if (!list.isEmpty()) {
            list.clear();
            return true;
        }
        return false;
    }

    @Override
    public List<Products> showCompare() {
        return list;
    }

    @Override
    public Products getProductInListByID(int productID) {
        for (Products p : list) {
            if (p.getProductID() == productID) {
                return p;
            }
        }
        return null;
    }
}
