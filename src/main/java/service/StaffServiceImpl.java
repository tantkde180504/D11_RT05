//package service;
//
//import entity.Staff;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//import repository.StaffRepository;
//
//import java.util.List;
//
//@Service
//public class StaffServiceImpl implements StaffService {
//
//    @Autowired
//    private StaffRepository staffRepository;
//
//    @Override
//    public void saveStaff(Staff staff) {
//        staffRepository.save(staff);
//    }
//
//    @Override
//    public List<Staff> getAllStaff() {
//        return staffRepository.findAll();
//    }
//}
