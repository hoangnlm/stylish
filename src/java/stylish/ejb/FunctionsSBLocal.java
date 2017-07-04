package stylish.ejb;

import java.util.List;
import javax.ejb.Local;
import stylish.entity.Functions;

/**
 *
 * @created on Jun 20, 2017, 3:17:25 PM
 * @author HoangNLM
 */
@Local
public interface FunctionsSBLocal {

    List<Functions> getList();

    Functions findFunctionsID(int functionID);

    Functions findFunctionsName(String functionName);

    List<Functions> getListById(Integer[] idList);

    List<Functions> getAllFunctions();

}
