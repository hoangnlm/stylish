package stylish.ejb;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import stylish.entity.ProductRating;

@Stateless
public class CommentSB implements CommentSBLocal {

    @PersistenceContext
    private EntityManager em;

    @Override
    public List<ProductRating> getAll() {
        return em.createQuery("SELECT p FROM ProductRating p", ProductRating.class).getResultList();
    }

    @Override
    public ProductRating getRatingByID(int productRatingID) {
        return em.find(ProductRating.class, productRatingID);
    }

    @Override
    public boolean update(ProductRating productRating) {
        ProductRating search = getRatingByID(productRating.getRatingID());

        if (search == null) {
            return false;
        }

        search.setStatus(productRating.getStatus());
        em.merge(search);

        return true;
    }

}
