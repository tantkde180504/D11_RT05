-- SQL Script for OTP Registration System
-- Add email_verified column to users table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'email_verified')
BEGIN
    ALTER TABLE users ADD email_verified BIT DEFAULT 0;
END

-- Create OTP verification table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='email_verification' AND xtype='U')
CREATE TABLE email_verification (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) NOT NULL,
    otp_code NVARCHAR(6) NOT NULL,
    user_data NVARCHAR(MAX) NOT NULL, -- JSON string containing user registration data
    created_at DATETIME2 DEFAULT GETDATE(),
    expires_at DATETIME2 NOT NULL,
    verified BIT DEFAULT 0,
    attempts INT DEFAULT 0,
    INDEX idx_email_otp (email, otp_code),
    INDEX idx_expires_at (expires_at)
);

-- Clean up expired OTP records (optional cleanup procedure)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='CleanupExpiredOTP' AND xtype='P')
BEGIN
    EXEC('
    CREATE PROCEDURE CleanupExpiredOTP
    AS
    BEGIN
        DELETE FROM email_verification 
        WHERE expires_at < GETDATE() OR attempts >= 3;
    END
    ')
END
