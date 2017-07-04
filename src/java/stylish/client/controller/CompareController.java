package stylish.client.controller;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import stylish.ejb.CompareStateFullBeanLocal;
import stylish.ejb.OrderStateLessBeanLocal;
import stylish.ejb.ProductStateLessBeanLocal;
import stylish.entity.Categories;
import stylish.entity.Products;

@Controller
@RequestMapping(value = "/compare/")
public class CompareController {

    private CompareStateFullBeanLocal compareStateFullBean = lookupCompareStateFullBeanLocal();
    private ProductStateLessBeanLocal productStateLessBean = lookupProductStateLessBeanLocal();
    private OrderStateLessBeanLocal orderStateLessBean = lookupOrderStateLessBeanLocal();

    // AJAX CLEAR COMPARE LIST
    @ResponseBody
    @RequestMapping(value = "ajax/clear", method = RequestMethod.GET)
    public String ajaxCompareClear() {
//        System.out.println("compare/ajax/clear");
        List<Products> list = compareStateFullBean.showCompare();
        if (!list.isEmpty()) {
            list.clear();
        }
        return "0"; // Success
    }

    // AJAX GET COMPARE LIST
    @ResponseBody
    @RequestMapping(value = "ajax/getCompare", method = RequestMethod.GET)
    public String getCompare() {

        String result = "";
        String itemDetails = "";
        String compareButton = "<div class=\"cart-btn\">"
                + "<a style=\"font-size: 9px; margin-right: 3px;\" href=\"compare/view.html\">COMPARE</a>"
                + "<button type=\"button\" onclick=\"compareClearClick();\" style=\""
                + "font-size: 9px;\n"
                + "text-transform: none;\n"
                + "height: 33px;\n"
                + "padding: 0 17px;\n"
                + "line-height: 33px;\n"
                + "font-weight: 700;\" class=\"btn btn-warning\">CLEAR</button> \n"
                + "</div>";
        List<Products> list = compareStateFullBean.showCompare();

        if (!list.isEmpty()) {
            for (Products p : list) {
                itemDetails += "<div class=\"ci-item\">\n"
                        + "        <img src=\"assets/images/products/" + p.getUrlImg() + "\" width=\"50\" alt=\"\"/>\n"
                        + "        <div class=\"ci-item-info\">\n"
                        + "            <h5>\n"
                        + "                <a style=\"font-weight: 700;\" href=\"" + p.getProductID() + "-" + p.getProductNameNA() + ".html\">\n"
                        + "                    " + p.getProductName() + "\n"
                        + "                </a>\n"
                        + "            </h5>\n"
                        + "            <p>Price: &nbsp $" + p.getPrice() + "</p>\n"
                        + "        </div>\n"
                        + "    </div>";
            }
        }

        result += "<div class=\"compare-info\">\n"
                + "<small>You have <em class=\"highlight\">" + list.size() + " item(s)</em> in compare list.</small>\n"
                + itemDetails
                + (list.isEmpty() ? "" : compareButton)
                + "</div>";

        return result;
    }

    // AJAX ADD ITEM TO COMPARE LIST
    @ResponseBody
    @RequestMapping(value = "ajax/add", method = RequestMethod.GET)
    public String ajaxAdd(@RequestParam("productID") Integer productID) {
        Products pro = orderStateLessBean.getProductByID(productID); //Tim trong danh sach san pham
//        System.out.println("ajaxAdd ================================================================================================================================================= " + pro);
        if (pro != null) {
            // Tim trong danh sach compare
            if (compareStateFullBean.getProductInListByID(productID) == null) {
                compareStateFullBean.addProduct(pro);
                return "0"; // Added to compare list successfully!
            }
            return "1"; // This product has been added!
        }
        return "2";  // This product not found!
    }

    // AJAX DELETE ITEM OUT OF LIST
    @ResponseBody
    @RequestMapping(value = "ajax/delete/{productID}", method = RequestMethod.GET)
    public String delete(@PathVariable("productID") int productID) {
        if (compareStateFullBean.deleteItem(productID)) {
            if (compareStateFullBean.showCompare().isEmpty()) {
                return "2";
            }
            return "0";
        }
        return "1";
    }

    @RequestMapping(value = "view")
    public String compare(ModelMap model, HttpServletRequest request) {
        //2 dòng này thêm để render ra menu chính
        List<Categories> cateList = productStateLessBean.categoryList();
        model.addAttribute("cateList", cateList);
        model.addAttribute("compareList", compareStateFullBean.showCompare());
        return "client/pages/compare";
    }

    @RequestMapping(value = "deleteAll", method = RequestMethod.GET)
    public String deleteCompare() {
        compareStateFullBean.deleteAll();
        return "redirect:/compare/view.html";
    }

    private OrderStateLessBeanLocal lookupOrderStateLessBeanLocal() {
        try {
            Context c = new InitialContext();
            return (OrderStateLessBeanLocal) c.lookup("java:global/stylish/OrderStateLessBean!stylish.ejb.OrderStateLessBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private ProductStateLessBeanLocal lookupProductStateLessBeanLocal() {
        try {
            Context c = new InitialContext();
            return (ProductStateLessBeanLocal) c.lookup("java:global/stylish/ProductStateLessBean!stylish.ejb.ProductStateLessBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private CompareStateFullBeanLocal lookupCompareStateFullBeanLocal() {
        try {
            Context c = new InitialContext();
            return (CompareStateFullBeanLocal) c.lookup("java:global/stylish/CompareStateFullBean!stylish.ejb.CompareStateFullBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

}
