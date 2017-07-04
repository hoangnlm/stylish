package stylish.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.io.Serializable;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;

@Entity
public class Functions implements Serializable {

    private static final long serialVersionUID = 5094320911100447279L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer functionID;
    private String functionName;
    @JoinTable(name = "permissions", joinColumns = {@JoinColumn(name = "functionID", referencedColumnName = "functionID")}, inverseJoinColumns = {@JoinColumn(name = "roleID", referencedColumnName = "roleID")})
    @ManyToMany
    @JsonManagedReference
    private List<Roles> rolesList;

    public Functions() {
    }

    public Functions(Integer functionID) {
        this.functionID = functionID;
    }

    public Functions(Integer functionID, String functionName) {
        this.functionID = functionID;
        this.functionName = functionName;
    }

    public Integer getFunctionID() {
        return functionID;
    }

    public void setFunctionID(Integer functionID) {
        this.functionID = functionID;
    }

    public String getFunctionName() {
        return functionName;
    }

    public void setFunctionName(String functionName) {
        this.functionName = functionName;
    }

    public List<Roles> getRolesList() {
        return rolesList;
    }

    public void setRolesList(List<Roles> rolesList) {
        this.rolesList = rolesList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (functionID != null ? functionID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Functions)) {
            return false;
        }
        Functions other = (Functions) object;
        if ((this.functionID == null && other.functionID != null) || (this.functionID != null && !this.functionID.equals(other.functionID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Functions{" + "functionID=" + functionID + ", functionName=" + functionName + '}';
    }

}
