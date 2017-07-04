package stylish.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.io.Serializable;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;

@Entity
public class Roles implements Serializable {

    private static final long serialVersionUID = 191165338794057028L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer roleID;
    private String roleName;
    @ManyToMany(mappedBy = "rolesList", fetch = FetchType.EAGER)
    @JsonManagedReference
    private List<Functions> functionsList;
    @OneToMany(mappedBy = "role")
    @JsonManagedReference
    private List<Users> userList;

    public Roles() {
    }

    public Roles(Integer roleID) {
        this.roleID = roleID;
    }

    public Roles(Integer roleID, String roleName) {
        this.roleID = roleID;
        this.roleName = roleName;
    }

    // Ham quan trong tu viet
    public Boolean hasFunction(int functionID) {
        if (functionsList != null && !functionsList.isEmpty()) {
            for (Functions f : functionsList) {
                if (f.getFunctionID() == functionID) {
                    return true;
                }
            }
        }
        return false;
    }

    public Integer getRoleID() {
        return roleID;
    }

    public void setRoleID(Integer roleID) {
        this.roleID = roleID;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public List<Functions> getFunctionsList() {
        return functionsList;
    }

    public void setFunctionsList(List<Functions> functionsList) {
        this.functionsList = functionsList;
    }

    public List<Users> getUserList() {
        return userList;
    }

    public void setUserList(List<Users> userList) {
        this.userList = userList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (roleID != null ? roleID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Roles)) {
            return false;
        }
        Roles other = (Roles) object;
        if ((this.roleID == null && other.roleID != null) || (this.roleID != null && !this.roleID.equals(other.roleID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Roles{" + "roleID=" + roleID + ", roleName=" + roleName + ", functionsList=" + functionsList + ", userList=" + userList + '}';
    }

}
