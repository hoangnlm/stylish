package stylish.common;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.springframework.stereotype.Component;
import stylish.ejb.UsersStateLessBeanLocal;
import stylish.entity.Functions;
import stylish.entity.Roles;
import stylish.entity.Users;

@Component
public class SharedFunctions {

    private UsersStateLessBeanLocal usersStateLessBean = lookupUsersStateLessBeanLocal();

    public List<Functions> getFunctionListFromEmail(String email) {
        Users user = usersStateLessBean.findUserByEmail(email);
        Roles role = user.getRole();
        List<Functions> result = new ArrayList<>();
        if (!role.getFunctionsList().isEmpty()) {
            result = role.getFunctionsList();
        }
        return result;
    }

    public String changeText(String text) {
        text = text.toLowerCase();
        String temp = Normalizer.normalize(text, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("").replaceAll("đ", "d").replaceAll(" ", "-");
    }

    public String encodePassword(String password) {
        StringBuilder sb = new StringBuilder();
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(password.getBytes());

            byte byteData[] = md.digest();

            //convert the byte to hex format method 1 
            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(SharedFunctions.class.getName()).log(Level.SEVERE, null, ex);
        }
        return sb.toString();
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
}
