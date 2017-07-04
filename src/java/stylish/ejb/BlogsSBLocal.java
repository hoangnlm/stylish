package stylish.ejb;

import java.util.List;
import javax.ejb.Local;
import stylish.entity.Blogs;

@Local
public interface BlogsSBLocal {

    public List<Blogs> getAllBlogs();

    public List<Blogs> getAllBlogsIndex();

    public List<Blogs> getAllBlogsIndexMonth();

    public List<Blogs> getAllBlogsAdmin();

    List<Blogs> getListBlogsByCategory(int blogCateID);

    public List<Blogs> getAllBlogsByMonth(int month);

    boolean blogAdd(Blogs newBlogs);

    Blogs findBlogsByID(int id);

    boolean editBlogs(Blogs targetBlogs);

    List<Blogs> findBlogsByTitle(String blogTitle, List<Integer> monthList);

//    BlogCategories findBlogCategoryByBlogCateName(String blogCateName);
    int deleteBlog(Blogs blog);

    public Integer getAllNumberBlogsInCate(int blogCateID);

}
