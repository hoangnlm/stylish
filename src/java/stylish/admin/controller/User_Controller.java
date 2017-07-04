package stylish.admin.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import stylish.ejb.FunctionsSBLocal;
import stylish.ejb.RolesStateLessBeanLocal;
import stylish.ejb.UsersStateLessBeanLocal;
import stylish.entity.Roles;
import stylish.entity.UserAddresses;
import stylish.entity.Users;

@Controller
@RequestMapping(value = "/admin/user/")
public class User_Controller {

    private RolesStateLessBeanLocal rolesStateLessBean = lookupRolesStateLessBeanLocal();
    private UsersStateLessBeanLocal usersStateLessBean = lookupUsersStateLessBeanLocal();
    private FunctionsSBLocal functionsSB = lookupFunctionsSBLocal();

    @RequestMapping(value = "list")
    public String userList(Model model) {
        List<Users> ulist = usersStateLessBean.getAllUsers();
        for (Users user : ulist) {
            user.getUserAddressList().isEmpty(); // Kich hoat eager loading
        }
        model.addAttribute("ulist", ulist);
        return "admin/pages/user-list";
    }

    @RequestMapping(value = "role")
    public String roleList(Model model) {
        List<Roles> rlist = rolesStateLessBean.getRole();
        model.addAttribute("rlist", rlist);
        return "admin/pages/user-role-list";
    }

    @ResponseBody
    @RequestMapping(value = "checkRoleName", method = RequestMethod.POST)
    public String roleCheck(ModelMap model) {
        List<Roles> roleNameList = rolesStateLessBean.findRName();
        ObjectMapper om = new ObjectMapper();
        String json = "";
        try {
            json = om.writeValueAsString(roleNameList);
        } catch (Exception e) {
            Logger.getLogger(User_Controller.class.getName()).log(Level.SEVERE, null, e);
        }
        return json;
    }

    @RequestMapping(value = "role/create", method = RequestMethod.GET)
    public String userRoleAdd(ModelMap model) {
        Roles role = new Roles();
        model.addAttribute("role", role);
        model.addAttribute("fList", functionsSB.getList());
        return "admin/pages/user-role-add";
    }

    @RequestMapping(value = "role/create", method = RequestMethod.POST)
    public String userRoleAdd(
            @ModelAttribute("role") Roles newRole,
            @RequestParam("_functionsList") Integer[] _functionsList,
            RedirectAttributes redirectAttributes) {

        if (_functionsList != null) {
            newRole.setFunctionsList(functionsSB.getListById(_functionsList));
        }

        int error = rolesStateLessBean.addRoles(newRole);

        switch (error) {
            case 1:
                redirectAttributes.addFlashAttribute("error", "<div class=\"col-md-12  alert alert-success\">Create New Roles Successfully!</div>");
                break;
            case 2:
                redirectAttributes.addFlashAttribute("error", "<div class=\"col-md-12  alert alert-danger\">FAILED!. Roles Existed! </div>");
                break;
            case 0:
                redirectAttributes.addFlashAttribute("error", "<div class=\"col-md-12  alert alert-danger\">FAILED!. Error was happened!</div>");
                break;
            default:
                break;
        }

        redirectAttributes.addFlashAttribute("role", newRole);
        return "redirect:/admin/user/role/create.html";

    }

    @ResponseBody
    @RequestMapping(value = "updateStatus", method = RequestMethod.POST)
    public String userStatusUpdate(@RequestParam("userID") Integer userID,
            @RequestParam("status") Short status) {
        if (usersStateLessBean.updateStatusUser(userID, status)) {
            return "OK";
        } else {
            return "FAIL";
        }
    }

    @ResponseBody
    @RequestMapping(value = "usersrole/edit", method = RequestMethod.POST)
    public String userRoleUpdate(ModelMap model, @RequestParam("userID") Integer userID,
            @RequestParam("roleID") Integer roleID) {
        if (rolesStateLessBean.editRolesForUsers(userID, roleID)) {
            return "OK";
        }
        return "FAIL";
    }

    @RequestMapping(value = "role/edit/{roleID}", method = RequestMethod.GET)
    public String userRoleUpdate(ModelMap model, @PathVariable("roleID") int roleID) {
        Roles roleupdate = rolesStateLessBean.findRoles(roleID);
//        System.out.println("isEmpty: " + roleupdate.getFunctionsList().isEmpty());
//        System.out.println("GET roleupdate: " + roleupdate.toString());
        model.addAttribute("roleupdate", rolesStateLessBean.findRoles(roleID));
        model.addAttribute("fList", functionsSB.getList());
        return "admin/pages/user-role-update";
    }

    @RequestMapping(value = "role/edit/{roleID}", method = RequestMethod.POST)
    public String userRoleUpdate(
            @PathVariable("roleID") int roleID,
            RedirectAttributes redirectAttributes,
            @RequestParam("_functionsList") Integer[] _functionsList,
            @ModelAttribute("roleupdate") Roles roleupdate) {

//        System.out.println("roleupdate: " + roleupdate.toString());
//        System.out.println("_functionsList: " + Arrays.toString(_functionsList));
//        System.out.println("functionsSB: " + functionsSB.getListById(_functionsList));

        if (_functionsList != null) {
            roleupdate.setFunctionsList(functionsSB.getListById(_functionsList));
        }
        
        int error = rolesStateLessBean.editRoles(roleupdate);
        switch (error) {
            case 1:
                redirectAttributes.addFlashAttribute("error", "<div class=\"col-md-12  alert alert-success\">Update Roles Successfully!</div>");
                break;
            case 2:
                redirectAttributes.addFlashAttribute("error", "<div class=\"col-md-12  alert alert-danger\">FAILED!. Roles Existed! </div>");
                break;
            case 0:
                redirectAttributes.addFlashAttribute("error", "<div class=\"col-md-12  alert alert-danger\">FAILED!. Error was happened!</div>");
                break;
            default:
                break;
        }
        redirectAttributes.addFlashAttribute("roleupdate", roleupdate);
        return "redirect:/admin/user/role/edit/" + roleID + ".html";
//            return "redirect:/admin/user/role.html";
    }

    @ResponseBody //Annotation này: dùng để trả về string nguyên thủy, ko trả về view.
    @RequestMapping(value = "ajax/getUserAddress", method = RequestMethod.POST)
    public String getUserAddress(@RequestParam("userID") Integer userID) {
        List<UserAddresses> userAddressList = usersStateLessBean.getUserByID(userID).getUserAddressList();
        ObjectMapper om = new ObjectMapper();
        String json = "";
        try {
//            System.out.println("user: " + userAddressList.get(0).getUser());
            json = om.writeValueAsString(userAddressList.get(0).getUser()); //Chuyển list sang chuỗi JSON (com.fasterxml.jackson.databind.ObjectMapper;)
        } catch (JsonProcessingException ex) {
            Logger.getLogger(User_Controller.class.getName()).log(Level.SEVERE, null, ex);
        }

        return json;
    }

    @ResponseBody
    @RequestMapping(value = "ajax/getUsersByID", method = RequestMethod.POST)
    public String getUsersByID(@RequestParam("userID") Integer userID) {
        List<Users> userIDList = usersStateLessBean.getAllUserID(userID);

        ObjectMapper om = new ObjectMapper();
        String json = "";
        try {
            json = om.writeValueAsString(userIDList);
        } catch (JsonProcessingException ex) {
            Logger.getLogger(User_Controller.class.getName()).log(Level.SEVERE, null, ex);
        }

        return json;
    }

    @ModelAttribute("roles")
    public List<Roles> getRole() {
        return rolesStateLessBean.getRole();
    }

    @RequestMapping(value = "role/delete/{roleID}", method = RequestMethod.POST)
    public String deteleRoleID(@PathVariable("roleID") int roleID, ModelMap model) {

        int error = rolesStateLessBean.deleteRole(roleID);
        switch (error) {
            case 2:
                model.addAttribute("error", "Không thể xóa");
                break;
            case 1:
                model.addAttribute("error", "OK");
                break;
            default:
                model.addAttribute("error", "lỗi");
                break;
        }

        return "redirect:/admin/user/role.html";
    }

    private UsersStateLessBeanLocal lookupUsersStateLessBeanLocal() {
        try {
            Context c = new InitialContext();
            return (UsersStateLessBeanLocal) c.lookup("java:global/stylish/UsersStateLessBean!stylish.ejb.UsersStateLessBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private RolesStateLessBeanLocal lookupRolesStateLessBeanLocal() {
        try {
            Context c = new InitialContext();
            return (RolesStateLessBeanLocal) c.lookup("java:global/stylish/RolesStateLessBean!stylish.ejb.RolesStateLessBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private FunctionsSBLocal lookupFunctionsSBLocal() {
        try {
            Context c = new InitialContext();
            return (FunctionsSBLocal) c.lookup("java:global/stylish/FunctionsSB!stylish.ejb.FunctionsSBLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

}
