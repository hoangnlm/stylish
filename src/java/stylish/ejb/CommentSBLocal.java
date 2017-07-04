package stylish.ejb;

import java.util.List;
import javax.ejb.Local;
import stylish.entity.ProductRating;

@Local
public interface CommentSBLocal {

    List<ProductRating> getAll();
    
    ProductRating getRatingByID(int productRatingID);

    boolean update(ProductRating productRating);

}
