package stylish.ejb;

import java.util.List;
import javax.ejb.Local;
import stylish.entity.Roles;
import stylish.entity.Users;

@Local
public interface RolesStateLessBeanLocal {

    Roles findRoles(int roleID);

    int addRoles(Roles roles);

    Roles findRoleName(String roleName);

    boolean editRolesForUsers(int userID, int roleID);

    List<Roles> getRole();

    int editRoles(Roles role);

    List<Users> listRoleUserID(int roleID);

    int deleteRole(int roleID);

    List<Roles> findRName();
}
