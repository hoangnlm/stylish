package stylish.ejb;

import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import stylish.entity.Functions;

/**
 *
 * @created on Jun 20, 2017, 3:17:25 PM
 * @author HoangNLM
 */
@Stateless
public class FunctionsSB implements FunctionsSBLocal {

    @PersistenceContext
    private EntityManager em;

    @Override
    public List<Functions> getListById(Integer[] idList) {
        List<Functions> all = getList();
        List<Functions> result = new ArrayList<>();
        if (!all.isEmpty()) {
            for (Functions f : all) {
                for (Integer id : idList) {
                    if (f.getFunctionID() == id) {
                        result.add(f);
                    }
                }
            }
        }
        return result;
    }

    @Override
    public List<Functions> getList() {
        // Lay tat ca tru 2 thang "Users" va "User Roles"
        Query q = em.createQuery("SELECT f FROM Functions f WHERE f.functionID != 1 AND f.functionID != 2", Functions.class);
        return q.getResultList();
    }

    @Override
    public List<Functions> getAllFunctions() {
        return em.createQuery("SELECT f FROM Functions f", Functions.class).getResultList();
    }

    @Override
    public Functions findFunctionsID(int functionID) {
        return em.find(Functions.class, functionID);
    }

    @Override
    public Functions findFunctionsName(String functionName) {
        Query q = em.createQuery("SELECT f FROM Functions f WHERE f.functionName = :functionName", Functions.class);
        q.setParameter("functionName", functionName);
        try {
            return (Functions) q.getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

}
