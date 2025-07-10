package com.mycompany.service;

import com.mycompany.entity.Address;
import com.mycompany.repository.AddressRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AddressService {
    
    @Autowired
    private AddressRepository addressRepository;
    
    /**
     * Lấy tất cả địa chỉ của user theo email
     */
    public List<Address> getAllAddressesByUserEmail(String userEmail) {
        return addressRepository.findByUserEmailOrderByCreatedAtDesc(userEmail);
    }
    
    /**
     * Đếm số lượng địa chỉ của user theo email
     */
    public long countAddressesByUserEmail(String userEmail) {
        return addressRepository.countByUserEmail(userEmail);
    }
    
    /**
     * Lấy địa chỉ theo ID và email user
     */
    public Optional<Address> getAddressById(Integer id, String userEmail) {
        return addressRepository.findByIdAndUserEmail(id, userEmail);
    }
    
    /**
     * Tạo địa chỉ mới
     */
    public Address createAddress(Address address) {
        // Nếu đây là địa chỉ mặc định, bỏ mặc định các địa chỉ khác
        if (address.getIsDefault() != null && address.getIsDefault()) {
            removeDefaultFromOtherAddresses(address.getUserEmail());
        }
        
        // Nếu đây là địa chỉ đầu tiên của user, tự động đặt làm mặc định
        if (addressRepository.countByUserEmail(address.getUserEmail()) == 0) {
            address.setIsDefault(true);
        }
        
        return addressRepository.save(address);
    }
    
    /**
     * Cập nhật địa chỉ
     */
    public Optional<Address> updateAddress(Integer id, String userEmail, Address addressDetails) {
        return addressRepository.findByIdAndUserEmail(id, userEmail)
                .map(address -> {
                    // Cập nhật thông tin
                    address.setRecipientName(addressDetails.getRecipientName());
                    address.setPhone(addressDetails.getPhone());
                    address.setHouseNumber(addressDetails.getHouseNumber());
                    address.setWard(addressDetails.getWard());
                    address.setDistrict(addressDetails.getDistrict());
                    address.setProvince(addressDetails.getProvince());
                    
                    // Nếu đặt làm mặc định, bỏ mặc định các địa chỉ khác
                    if (addressDetails.getIsDefault() != null && addressDetails.getIsDefault()) {
                        removeDefaultFromOtherAddresses(userEmail);
                        address.setIsDefault(true);
                    } else if (addressDetails.getIsDefault() != null) {
                        address.setIsDefault(addressDetails.getIsDefault());
                    }
                    
                    return addressRepository.save(address);
                });
    }
    
    /**
     * Xóa địa chỉ
     */
    public boolean deleteAddress(Integer id, String userEmail) {
        Optional<Address> addressOpt = addressRepository.findByIdAndUserEmail(id, userEmail);
        if (addressOpt.isPresent()) {
            Address address = addressOpt.get();
            boolean wasDefault = address.getIsDefault() != null && address.getIsDefault();
            
            addressRepository.delete(address);
            
            // Nếu xóa địa chỉ mặc định, tự động đặt địa chỉ khác làm mặc định
            if (wasDefault) {
                setFirstAddressAsDefault(userEmail);
            }
            
            return true;
        }
        return false;
    }
    
    /**
     * Đặt địa chỉ làm mặc định
     */
    public Optional<Address> setDefaultAddress(Integer id, String userEmail) {
        return addressRepository.findByIdAndUserEmail(id, userEmail)
                .map(address -> {
                    // Bỏ mặc định tất cả địa chỉ khác
                    removeDefaultFromOtherAddresses(userEmail);
                    
                    // Đặt địa chỉ này làm mặc định
                    address.setIsDefault(true);
                    return addressRepository.save(address);
                });
    }
    
    /**
     * Validate địa chỉ
     */
    public boolean validateAddress(Address address) {
        System.out.println("=== VALIDATING ADDRESS ===");
        System.out.println("Address: " + address);
        
        if (address == null) {
            System.out.println("Address is null");
            return false;
        }
        
        // Check recipient name
        if (address.getRecipientName() == null || address.getRecipientName().trim().isEmpty()) {
            System.out.println("Recipient name is null or empty");
            return false;
        }
        
        // Check phone
        if (address.getPhone() == null || address.getPhone().trim().isEmpty()) {
            System.out.println("Phone is null or empty");
            return false;
        }
        
        // Check house number
        if (address.getHouseNumber() == null || address.getHouseNumber().trim().isEmpty()) {
            System.out.println("House number is null or empty");
            return false;
        }
        
        // Check ward
        if (address.getWard() == null || address.getWard().trim().isEmpty()) {
            System.out.println("Ward is null or empty");
            return false;
        }
        
        // Check district
        if (address.getDistrict() == null || address.getDistrict().trim().isEmpty()) {
            System.out.println("District is null or empty");
            return false;
        }
        
        // Check province
        if (address.getProvince() == null || address.getProvince().trim().isEmpty()) {
            System.out.println("Province is null or empty");
            return false;
        }
        
        // Check user email
        if (address.getUserEmail() == null || address.getUserEmail().trim().isEmpty()) {
            System.out.println("User email is null or empty");
            return false;
        }
        
        System.out.println("Address validation passed");
        return true;
    }
    
    /**
     * Bỏ mặc định tất cả địa chỉ khác của user
     */
    private void removeDefaultFromOtherAddresses(String userEmail) {
        addressRepository.updateAllToNotDefault(userEmail);
    }
    
    /**
     * Đặt địa chỉ đầu tiên làm mặc định (khi xóa địa chỉ mặc định)
     */
    private void setFirstAddressAsDefault(String userEmail) {
        List<Address> addresses = addressRepository.findByUserEmailOrderByCreatedAtDesc(userEmail);
        if (!addresses.isEmpty()) {
            Address firstAddress = addresses.get(0);
            firstAddress.setIsDefault(true);
            addressRepository.save(firstAddress);
        }
    }
}
