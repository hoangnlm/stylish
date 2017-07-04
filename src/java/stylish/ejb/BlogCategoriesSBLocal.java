package stylish.ejb;

import java.util.List;
import javax.ejb.Local;
import stylish.entity.BlogCategories;

@Local
public interface BlogCategoriesSBLocal {

    List<BlogCategories> getBlogCategoriesList();

    int addNewBlogCategories(BlogCategories newBlogCate);

    boolean updateCategories(BlogCategories cate);

    int findCategoriesByName(String blogCateName);

    BlogCategories findCategoryByID(int blogCateID);

    int deleteCategory(BlogCategories blogCategories);

}
