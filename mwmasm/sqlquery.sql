USE [mwmasm];
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'';
    SELECT @sql +=
        N'ALTER TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) +
        N' NOCHECK CONSTRAINT ALL;' + CHAR(13)
    FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE t.is_ms_shipped = 0;

    EXEC sp_executesql @sql;
    SET @sql = N'';
    SELECT @sql +=
        N'DELETE FROM ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) + N';' + CHAR(13)
    FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE t.is_ms_shipped = 0;

    EXEC sp_executesql @sql;

    SET @sql = N'';
    SELECT @sql +=
        N'DBCC CHECKIDENT (''' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) + N''', RESEED, 0);' + CHAR(13)
    FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE t.is_ms_shipped = 0
      AND EXISTS (
          SELECT 1
          FROM sys.columns c
          WHERE c.object_id = t.object_id
            AND c.is_identity = 1
      );

    EXEC sp_executesql @sql;

    SET @sql = N'';
    SELECT @sql +=
        N'ALTER TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) +
        N' WITH CHECK CHECK CONSTRAINT ALL;' + CHAR(13)
    FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE t.is_ms_shipped = 0;

    EXEC sp_executesql @sql;

    COMMIT TRAN;

    PRINT 'Done: all user tables cleared and identity reseeded (next insert starts at 1).';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    PRINT 'FAILED. Error message: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO

INSERT INTO dbo.tblCategories ([name], [description])
VALUES
(N'Keyboards & Mice',        N'Input devices and peripherals'),
(N'Headsets & Audio',        N'Headsets, speakers, microphones'),
(N'Cables & Adapters',       N'HDMI, USB, Type-C adapters'),
(N'Storage & Memory',        N'SSD, HDD, USB drives, RAM'),
(N'Gaming Accessories',      N'Controllers, mousepads, stands');

SET NOCOUNT ON;

DECLARE
    @catKeyboards INT,
    @catAudio     INT,
    @catCables    INT,
    @catStorage   INT,
    @catGaming    INT;

SELECT @catKeyboards = categoryId FROM dbo.tblCategories WHERE [name] = N'Keyboards & Mice';
SELECT @catAudio     = categoryId FROM dbo.tblCategories WHERE [name] = N'Headsets & Audio';
SELECT @catCables    = categoryId FROM dbo.tblCategories WHERE [name] = N'Cables & Adapters';
SELECT @catStorage   = categoryId FROM dbo.tblCategories WHERE [name] = N'Storage & Memory';
SELECT @catGaming    = categoryId FROM dbo.tblCategories WHERE [name] = N'Gaming Accessories';


INSERT INTO dbo.tblProducts (categoryId, [name], [description], price, imageUrl, stockQuantity)
VALUES
(@catKeyboards, N'RGB Mechanical Keyboard (TKL)', N'Tenkeyless mechanical keyboard with RGB lighting and anti-ghosting for gaming and typing.', 189.90, N'/productImages/placeholder-image.jpg', 30),
(@catKeyboards, N'Wireless Mechanical Keyboard (Full Size)', N'Full-size wireless mechanical keyboard with long battery life and quiet stabilizers.', 229.00, N'/productImages/placeholder-image.jpg', 20),
(@catKeyboards, N'Ergonomic Wireless Mouse', N'Comfort ergonomic mouse with adjustable DPI and silent clicks for productivity.', 79.90,  N'/productImages/placeholder-image.jpg', 40),
(@catKeyboards, N'Gaming Mouse (Adjustable DPI)', N'High-precision gaming mouse with DPI switch, textured grip, and smooth glide feet.', 99.90,  N'/productImages/placeholder-image.jpg', 35),
(@catKeyboards, N'Keyboard + Mouse Combo (Wireless)', N'Wireless keyboard and mouse combo, compact layout, plug-and-play receiver.', 119.90, N'/productImages/placeholder-image.jpg', 25),


(@catAudio, N'Gaming Headset (Surround Ready)', N'Over-ear gaming headset with noise-isolating earcups and clear voice mic.', 149.90, N'/productImages/placeholder-image.jpg', 28),
(@catAudio, N'Wireless Headset (Low Latency)', N'Wireless headset with stable connection, low-latency mode, and comfortable padding.', 269.00, N'/productImages/placeholder-image.jpg', 18),
(@catAudio, N'USB Condenser Microphone', N'USB desktop microphone for streaming and calls, includes shock mount and pop filter.', 139.90, N'/productImages/placeholder-image.jpg', 22),
(@catAudio, N'2.0 Desktop Speakers', N'Compact stereo speakers with clean mid/high output, ideal for desk setups.', 89.90,  N'/productImages/placeholder-image.jpg', 26),
(@catAudio, N'USB Sound Card Adapter', N'External USB audio adapter for headphone + mic ports, useful for laptops and PCs.', 39.90,  N'/productImages/placeholder-image.jpg', 60),

(@catCables, N'USB-C to HDMI Adapter', N'USB-C to HDMI adapter for laptop-to-monitor connection, supports high-resolution output.', 59.90,  N'/productImages/placeholder-image.jpg', 50),
(@catCables, N'USB-C Fast Charging Cable (2m)', N'Durable USB-C charging cable with reinforced connector, suitable for fast charging.', 29.90,  N'/productImages/placeholder-image.jpg', 80),
(@catCables, N'HDMI Cable (High Speed)', N'High-speed HDMI cable for stable video output between PC/console and display.', 24.90,  N'/productImages/placeholder-image.jpg', 90),
(@catCables, N'USB-C Multiport Hub', N'Multiport hub with USB-A, HDMI, and card reader for productivity on the go.', 119.90, N'/productImages/placeholder-image.jpg', 35),
(@catCables, N'USB to Ethernet Adapter', N'USB network adapter for reliable wired internet, plug-and-play on most systems.', 49.90,  N'/productImages/placeholder-image.jpg', 45),

(@catStorage, N'NVMe SSD 1TB (M.2)', N'High-speed NVMe M.2 SSD for fast boot and load times; great for upgrades.', 299.00, N'/productImages/placeholder-image.jpg', 15),
(@catStorage, N'External HDD 2TB (USB 3.0)', N'Portable 2TB external hard drive for backups and extra storage.', 219.90, N'/productImages/placeholder-image.jpg', 18),
(@catStorage, N'USB Flash Drive 128GB', N'Compact USB flash drive for quick file transfers and portable storage.', 39.90,  N'/productImages/placeholder-image.jpg', 55),
(@catStorage, N'MicroSD Card 256GB (UHS)', N'High-capacity microSD card suitable for cameras, handheld devices, and storage expansion.', 69.90,  N'/productImages/placeholder-image.jpg', 40),
(@catStorage, N'DDR4 RAM 16GB Kit (2x8GB)', N'DDR4 memory kit for smoother multitasking and improved system responsiveness.', 159.90, N'/productImages/placeholder-image.jpg', 20),

(@catGaming, N'Wireless Game Controller', N'Comfortable wireless controller compatible with PC; responsive buttons and grip.', 129.90, N'/productImages/placeholder-image.jpg', 25),
(@catGaming, N'XL Gaming Mousepad', N'Extra-large mousepad with smooth surface and non-slip base for consistent tracking.', 39.90,  N'/productImages/placeholder-image.jpg', 70),
(@catGaming, N'Laptop Cooling Pad', N'Cooling pad with adjustable fan speed and ergonomic angle to reduce heat buildup.', 79.90,  N'/productImages/placeholder-image.jpg', 30),
(@catGaming, N'Headset Stand (Desk)', N'Desk headset stand for tidy setup and cable management, stable base design.', 29.90,  N'/productImages/placeholder-image.jpg', 60),
(@catGaming, N'Controller Charging Dock', N'Charging dock for controllers with status indicator; helps keep gaming gear ready.', 49.90,  N'/productImages/placeholder-image.jpg', 35);


