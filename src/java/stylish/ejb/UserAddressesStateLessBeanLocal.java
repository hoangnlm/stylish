package stylish.ejb;

import java.util.List;
import javax.ejb.Local;
import stylish.entity.UserAddresses;
import stylish.entity.Users;

@Local
public interface UserAddressesStateLessBeanLocal {

    List<UserAddresses> getAddressUser();

    void addAddressUser(UserAddresses userAddresses, int userID);

    UserAddresses findAddress(int userID);

    UserAddresses findPhone(int userID);

    int editAddressUser(UserAddresses userAddresses, int userID);

    Users findUserID(int userID);

    UserAddresses findID(int userID);

    void addUser(Users user);

    List<UserAddresses> AddressListUser(int userID);

    UserAddresses findAddressID(int addressID);

    int editAddress(int userID, int addressID);

    void deleteAddress(int addressID);

}
