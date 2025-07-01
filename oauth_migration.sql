-- OAuth Integration Migration Script
-- This script adds OAuth fields to the existing users table and migrates data
-- Run this script on your database before deploying the updated code

USE gundamhobby;
GO

PRINT '=== Starting OAuth Integration Migration ===';

-- Step 1: Add OAuth fields to users table if they don't exist
PRINT 'Step 1: Adding OAuth fields to users table...';

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'provider')
BEGIN
    ALTER TABLE users ADD provider NVARCHAR(50) NULL;
    PRINT 'Added provider column to users table';
END
ELSE
    PRINT 'provider column already exists in users table';

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'provider_id')
BEGIN
    ALTER TABLE users ADD provider_id NVARCHAR(255) NULL;
    PRINT 'Added provider_id column to users table';
END
ELSE
    PRINT 'provider_id column already exists in users table';

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'picture')
BEGIN
    ALTER TABLE users ADD picture NVARCHAR(500) NULL;
    PRINT 'Added picture column to users table';
END
ELSE
    PRINT 'picture column already exists in users table';

-- Step 2: Create indexes for better performance (optional)
PRINT 'Step 2: Creating indexes...';

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_users_provider_id' AND object_id = OBJECT_ID('users'))
BEGIN
    CREATE INDEX IX_users_provider_id ON users(provider_id);
    PRINT 'Created index on provider_id';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_users_provider' AND object_id = OBJECT_ID('users'))
BEGIN
    CREATE INDEX IX_users_provider ON users(provider);
    PRINT 'Created index on provider';
END

-- Step 3: Migrate data from oauth_users table if it exists
PRINT 'Step 3: Migrating data from oauth_users table...';

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'oauth_users')
BEGIN
    PRINT 'oauth_users table found, starting migration...';
    
    -- Add migration tracking column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'oauth_users' AND COLUMN_NAME = 'migrated_to_users')
    BEGIN
        ALTER TABLE oauth_users ADD migrated_to_users BIT DEFAULT 0;
        PRINT 'Added migration tracking column to oauth_users';
    END
    
    DECLARE @MigratedCount INT = 0;
    DECLARE @UpdatedCount INT = 0;
    DECLARE @email NVARCHAR(255);
    DECLARE @name NVARCHAR(255);
    DECLARE @picture NVARCHAR(500);
    DECLARE @provider NVARCHAR(50);
    DECLARE @provider_id NVARCHAR(255);
    DECLARE @role NVARCHAR(50);
    DECLARE @first_name NVARCHAR(255);
    DECLARE @last_name NVARCHAR(255);
    
    -- Cursor to process each OAuth user
    DECLARE oauth_cursor CURSOR FOR
    SELECT email, name, picture, provider, provider_id, role
    FROM oauth_users 
    WHERE migrated_to_users = 0 OR migrated_to_users IS NULL;
    
    OPEN oauth_cursor;
    FETCH NEXT FROM oauth_cursor INTO @email, @name, @picture, @provider, @provider_id, @role;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Split name into first_name and last_name
        SET @first_name = CASE WHEN CHARINDEX(' ', @name) > 0 
                              THEN LEFT(@name, CHARINDEX(' ', @name) - 1) 
                              ELSE @name END;
        SET @last_name = CASE WHEN CHARINDEX(' ', @name) > 0 
                             THEN SUBSTRING(@name, CHARINDEX(' ', @name) + 1, LEN(@name)) 
                             ELSE '' END;
        
        -- Check if user already exists in users table
        IF EXISTS (SELECT 1 FROM users WHERE email = @email)
        BEGIN
            -- Update existing user with OAuth info
            UPDATE users 
            SET provider = @provider,
                provider_id = @provider_id,
                picture = @picture,
                first_name = COALESCE(NULLIF(first_name, ''), @first_name),
                last_name = COALESCE(NULLIF(last_name, ''), @last_name)
            WHERE email = @email;
            
            SET @UpdatedCount = @UpdatedCount + 1;
            PRINT 'Updated existing user: ' + @email;
        END
        ELSE
        BEGIN
            -- Insert new user
            INSERT INTO users (email, first_name, last_name, role, provider, provider_id, picture, password)
            VALUES (@email, @first_name, @last_name, ISNULL(@role, 'CUSTOMER'), @provider, @provider_id, @picture, 'OAUTH_USER');
            
            SET @MigratedCount = @MigratedCount + 1;
            PRINT 'Migrated new user: ' + @email;
        END
        
        -- Mark as migrated
        UPDATE oauth_users SET migrated_to_users = 1 WHERE email = @email;
        
        FETCH NEXT FROM oauth_cursor INTO @email, @name, @picture, @provider, @provider_id, @role;
    END
    
    CLOSE oauth_cursor;
    DEALLOCATE oauth_cursor;
    
    PRINT 'Migration complete:';
    PRINT '  - New users migrated: ' + CAST(@MigratedCount AS NVARCHAR(10));
    PRINT '  - Existing users updated: ' + CAST(@UpdatedCount AS NVARCHAR(10));
END
ELSE
BEGIN
    PRINT 'oauth_users table not found, skipping data migration';
END

-- Step 4: Verify migration
PRINT 'Step 4: Verification...';

DECLARE @TotalUsers INT;
DECLARE @OAuthUsers INT;

SELECT @TotalUsers = COUNT(*) FROM users;
SELECT @OAuthUsers = COUNT(*) FROM users WHERE provider IS NOT NULL;

PRINT 'Verification results:';
PRINT '  - Total users in users table: ' + CAST(@TotalUsers AS NVARCHAR(10));
PRINT '  - Users with OAuth provider: ' + CAST(@OAuthUsers AS NVARCHAR(10));

-- Step 5: Optional - Archive oauth_users table
PRINT 'Step 5: Optional cleanup...';
PRINT 'Note: The oauth_users table has been kept for reference.';
PRINT 'You can manually drop it after verifying the migration is successful:';
PRINT '-- DROP TABLE oauth_users;';

PRINT '=== OAuth Integration Migration Complete ===';
GO
