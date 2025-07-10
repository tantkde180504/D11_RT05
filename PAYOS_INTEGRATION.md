# PayOS Integration for 43 Gundam Hobby

## Overview
This project integrates PayOS payment gateway into the 43 Gundam Hobby e-commerce application, allowing customers to pay for their orders using various payment methods supported by PayOS.

## Features
- **PayOS Hosted Payment Page**: Customers are redirected to PayOS hosted payment page for secure payment processing
- **Multiple Payment Methods**: Support for bank transfers, e-wallets, and other payment methods through PayOS
- **Order Management**: Integration with existing order system to track payment status
- **Success/Cancel Pages**: Custom pages for payment success and cancellation scenarios

## Configuration

### 1. PayOS Account Setup
1. Sign up for a PayOS account at [https://payos.vn](https://payos.vn)
2. Create a payment channel and obtain your credentials:
   - Client ID
   - API Key
   - Checksum Key

### 2. Application Configuration
Update your `application.properties` file with your PayOS credentials:

```properties
# PayOS Configuration
payos.client-id=YOUR_CLIENT_ID
payos.api-key=YOUR_API_KEY
payos.checksum-key=YOUR_CHECKSUM_KEY
payos.return-url=http://localhost:8080/payment/success
payos.cancel-url=http://localhost:8080/payment/cancel
```

**Important**: Replace `YOUR_CLIENT_ID`, `YOUR_API_KEY`, and `YOUR_CHECKSUM_KEY` with your actual PayOS credentials.

### 3. Dependencies
The PayOS Java SDK has been added to your `pom.xml`:

```xml
<dependency>
    <groupId>vn.payos</groupId>
    <artifactId>payos-java</artifactId>
    <version>1.0.1</version>
</dependency>
```

## Usage

### 1. Payment Flow
1. Customer adds items to cart
2. Customer proceeds to checkout (`payment.jsp`)
3. Customer fills in delivery information
4. Customer selects "PayOS" as payment method
5. Customer clicks "Đặt hàng" (Place Order)
6. System creates order and generates PayOS payment link
7. Customer is redirected to PayOS payment page
8. After payment completion, customer is redirected to success/cancel page
9. System updates order status based on payment result

### 2. API Endpoints

#### POST `/api/payment`
Creates a new order and payment link (for PayOS) or processes COD payment.

**Request Body:**
```json
{
    "fullName": "Nguyễn Văn A",
    "phone": "0123456789",
    "address": "123 Đường ABC, Quận 1, TP.HCM",
    "note": "Giao hàng giờ hành chính",
    "paymentMethod": "BANK_TRANSFER"
}
```

**Response (PayOS):**
```json
{
    "success": true,
    "message": "Đã tạo link thanh toán!",
    "checkoutUrl": "https://pay.payos.vn/web/...",
    "orderCode": 12345,
    "orderNumber": "ORD123456"
}
```

#### POST `/api/payment/payos/confirm`
Confirms PayOS payment status (called automatically by success/cancel pages).

**Request Body:**
```json
{
    "orderCode": 12345,
    "status": "PAID"
}
```

#### GET `/payment/success`
Success page endpoint - redirects to `success.html`

#### GET `/payment/cancel`
Cancel page endpoint - redirects to `cancel.html`

### 3. Order Status Flow
- **PENDING**: Order created, payment pending
- **PAID**: Payment successful (PayOS)
- **CONFIRMED**: Order confirmed (COD)
- **CANCELLED**: Payment cancelled/failed

## Testing

### 1. Local Testing
1. Start your application: `mvn spring-boot:run`
2. Navigate to `http://localhost:8080`
3. Add items to cart
4. Go to payment page
5. Select PayOS payment method
6. Complete the payment flow

### 2. PayOS Test Environment
PayOS provides a test environment where you can simulate payments without actual money transfer. Check PayOS documentation for test credentials.

## Files Modified/Created

### Backend Files
- `PaymentController.java` - Updated to handle PayOS payments
- `PayOSConfig.java` - Configuration class for PayOS
- `pom.xml` - Added PayOS dependency
- `application.properties` - Added PayOS configuration

### Frontend Files
- `payment.jsp` - Updated payment form to support PayOS
- `success.html` - Payment success page
- `cancel.html` - Payment cancellation page

## Security Considerations
1. **Never expose your PayOS credentials** in client-side code
2. **Use HTTPS** in production environment
3. **Validate payment confirmations** server-side
4. **Implement webhook handlers** for production use (recommended)

## Troubleshooting

### Common Issues
1. **"Payment link creation failed"**: Check your PayOS credentials
2. **"Order not found"**: Ensure order is created before payment link generation
3. **"Payment not confirmed"**: Check success/cancel page JavaScript console for errors

### Debug Mode
Enable debug logging in `application.properties`:
```properties
logging.level.com.mycompany=DEBUG
```

## Support
- PayOS Documentation: [https://docs.payos.vn](https://docs.payos.vn)
- PayOS Support: support@payos.vn
- Application Issues: Check application logs and debug mode

## Next Steps
1. **Production Setup**: Update URLs and credentials for production environment
2. **Webhook Implementation**: Implement PayOS webhooks for real-time payment updates
3. **Error Handling**: Enhance error handling and user feedback
4. **Testing**: Thoroughly test payment flows before going live
