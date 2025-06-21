package com.mycompany;

import java.util.List;

public interface UserService {
    User createStaffAccount(User user);

    List<User> getAllStaffs(); // ✅ Thêm dòng này
}
