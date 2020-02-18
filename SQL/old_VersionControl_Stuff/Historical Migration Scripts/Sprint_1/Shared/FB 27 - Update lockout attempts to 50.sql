-- FB 27 - Change default lockout attempts to 50 from 5
UPDATE	SecuritySetting
SET		LockoutAttempts = 50
WHERE	LockoutAttempts = 5