package stylish.admin.controller;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import stylish.ejb.CommentSBLocal;
import stylish.entity.ProductRating;

@Controller
@RequestMapping(value = "/admin/comment")
public class Comment_Controller {

    private CommentSBLocal commentSB = lookupCommentSBLocal();

    @RequestMapping(value = "view")
    public String userList(Model model) {
        List<ProductRating> ratingList = commentSB.getAll();
        model.addAttribute("ratingList", ratingList);
        return "admin/pages/comment-list";
    }

    @ResponseBody
    @RequestMapping(value = "update", method = RequestMethod.POST)
    public String userStatusUpdate(@RequestParam("ratingID") Integer ratingID,
            @RequestParam("status") Short status) {
        ProductRating update = new ProductRating();
        update.setRatingID(ratingID);
        update.setStatus(status);
        if (commentSB.update(update)) {
            return "0";     // Success
        }
        return "1";     // Error not found
    }

    private CommentSBLocal lookupCommentSBLocal() {
        try {
            Context c = new InitialContext();
            return (CommentSBLocal) c.lookup("java:global/stylish/CommentSB!stylish.ejb.CommentSBLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

}
