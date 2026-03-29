

-- Populating the tables 

INSERT INTO `clinic_supplier` (`supplier_id`, `supplier_name`, `contact_person`, `supplier_contact_number`, `supplier_address`) VALUES
(1, 'Mr. Supplier', 'Mang Tani', '09060585960', 'Over There');

INSERT INTO `clinic_product` (`product_name`, `product_type`, `description`, `unit_cost`, `supplier_id`) VALUES
('Esthetmax Jelly Mask', 'Add-On', NULL, 599.00, 1),
('Special Mask', 'Add-On', NULL, 200.00, 1),
('Jelly Mask', 'Add-On', NULL, 400.00, 1),
('Gold Mask', 'Add-On', NULL, 550.00, 1),
('Extraction', 'Add-On', NULL, 250.00, 1),
('Ear Gun Piercing', 'Add-On', NULL, 450.00, 1),
('Keloid Injection', 'Add-On', 'Per unit', 150.00, 1),
('Acne Shot', 'Add-On', 'Per unit', 150.00, 1),
('Acne Laser', 'Add-On', NULL, 250.00, 1),
('Topical Anesthesia', 'Add-On', NULL, 500.00, 1),
('Local Anesthesia', 'Add-On', NULL, 600.00, 1),
('Gluta IV Push', 'Add-On', 'Per vial', 800.00, 1),
('Night Cream (10g)', 'Cream', NULL, 380.00, 1),
('Night Cream (25g)', 'Cream', NULL, 780.00, 1),
('Day Cream (10g)', 'Cream', NULL, 380.00, 1),
('Day Cream (25g)', 'Cream', NULL, 780.00, 1),
('Peeling Cream (10g)', 'Cream', NULL, 480.00, 1),
('Peeling Cream (25g)', 'Cream', NULL, 880.00, 1),
('Sunscreen Gel (10g)', 'Cream', NULL, 420.00, 1),
('Sunscreen Foundation (10g)', 'Cream', NULL, 420.00, 1),
('Sunblock Foundation (10g)', 'Cream', NULL, 420.00, 1),
('Clindamycin Cream (10g)', 'Cream', NULL, 400.00, 1),
('Collagen Cream (10g)', 'Cream', NULL, 480.00, 1),
('Glycolic Cream (10g)', 'Cream', NULL, 420.00, 1),
('Hydrocortisone Cream (10g)', 'Cream', NULL, 420.00, 1),
('Erythromycin Cream (10g)', 'Cream', NULL, 300.00, 1),
('Underarm Whitening (10g)', 'Cream', NULL, 420.00, 1),
('Cleansing Solution (60ml)', 'Solution', NULL, 220.00, 1),
('Cleansing Solution (150ml)', 'Solution', NULL, 400.00, 1),
('Clarifying Solution (60ml)', 'Solution', NULL, 300.00, 1),
('Clarifying Solution (150ml)', 'Solution', NULL, 450.00, 1),
('Clindamycin Solution (60ml)', 'Solution', NULL, 390.00, 1),
('Body Astringent (150ml)', 'Solution', NULL, 650.00, 1),
('Brightening Soap (90g)', 'Soap', NULL, 200.00, 1),
('Bleaching Soap (90g)', 'Soap', NULL, 280.00, 1),
('Hydramide Soap (150g)', 'Soap', NULL, 420.00, 1),
('Collagen Serum', 'Serum', NULL, 450.00, 1),
('Miracle Serum', 'Serum', NULL, 450.00, 1),
('Tomato Serum', 'Serum', NULL, 450.00, 1),
('Hydrating Serum', 'Serum', NULL, 450.00, 1),
('Anti-Melasma Serum', 'Serum', NULL, 500.00, 1),
('Glass Serum', 'Serum', NULL, 450.00, 1),
('Gold Serum', 'Serum', NULL, 450.00, 1),
('Retinol Serum', 'Serum', NULL, 500.00, 1),
('Niacinamide Serum', 'Serum', NULL, 450.00, 1),
('Hyaluronic Serum', 'Serum', NULL, 450.00, 1),
('Puff Away Serum', 'Serum', NULL, 450.00, 1);

INSERT INTO `clinic_treatment` (`treatment_name`, `treatment_type`, `treatment_cost`, `description`) VALUES
('Deluxe Facial', 'Facial', 499.00, NULL),
('Whitening Glow Facial', 'Facial', 599.00, NULL),
('Oil Control Facial', 'Facial', 799.00, NULL),
('Collagen Facial', 'Facial', 699.00, NULL),
('Skin Brightening Treatment', 'Facial', 999.00, NULL),
('Teen Acne Clear Facial', 'Facial', 999.00, NULL),
('Adult Acne Clear Facial', 'Facial', 1499.00, 'Buy 5 Sessions, Get 1 Free'),
('Facial Dermaplanning', 'Premium Facial', 1499.00, NULL),
('C Aesthetic Luxe Facial', 'Premium Facial', 2499.00, NULL),
('C Aesthetic ZO Facial', 'Premium Facial', 3499.00, NULL),
('Full Hydra Facial Treatment', 'Premium Facial', 3499.00, NULL),
('Full Hydra Facial + Pico/Carbon', 'Premium Facial', 6000.00, NULL),
('Korean Facial', 'Premium Facial', 2999.00, NULL),
('Micro Corrective Peel - Per Session', 'Face Peel', 2499.00, NULL),
('Micro Corrective Peel - Package (2 sessions)', 'Face Peel', 4500.00, NULL),
('Standard Peel - Per Session', 'Face Peel', 3499.00, NULL),
('Standard Peel - Package (2 sessions)', 'Face Peel', 5999.00, NULL),
('Advance Corrective Peel - Per Session', 'Face Peel', 3899.00, NULL),
('Advance Corrective Peel - Package (3 sessions)', 'Face Peel', 9599.00, NULL),
('Spot Treatment Peel - Per Session', 'Face Peel', 2199.00, NULL),
('Spot Treatment Peel - Package (2 sessions)', 'Face Peel', 3499.00, NULL),
('TCA Cross / Ice Pick Peel - Per Session', 'Face Peel', 4599.00, NULL),
('TCA Cross / Ice Pick Peel - Package (3 sessions)', 'Face Peel', 11999.00, NULL),
('Neck Whitening Peel', 'Body Peel', 2599.00, 'Buy 4 Sessions, Get 1 Free'),
('Underarm Whitening Peel', 'Body Peel', 2499.00, 'Buy 4 Sessions, Get 1 Free'),
('Arm Whitening Peel', 'Body Peel', 4999.00, 'Buy 4 Sessions, Get 1 Free'),
('Chest Whitening Peel', 'Body Peel', 4499.00, 'Buy 4 Sessions, Get 1 Free'),
('Back Peel', 'Body Peel', 4499.00, 'Buy 4 Sessions, Get 1 Free'),
('Groin Whitening Peel', 'Body Peel', 2499.00, 'Buy 4 Sessions, Get 1 Free'),
('Full Leg Peel', 'Body Peel', 9999.00, 'Buy 4 Sessions, Get 1 Free'),
('Half Leg Peel', 'Body Peel', 6999.00, 'Buy 4 Sessions, Get 1 Free'),
('Full Face', 'Whitening Laser', 3499.00, 'Buy 5 Sessions, Get 1 Free'),
('Partial Face', 'Whitening Laser', 2499.00, 'Buy 5 Sessions, Get 1 Free'),
('Nape', 'Whitening Laser', 1499.00, 'Buy 5 Sessions, Get 1 Free'),
('Underarm', 'Whitening Laser', 1599.00, 'Buy 5 Sessions, Get 1 Free'),
('Groin Area', 'Whitening Laser', 1499.00, 'Buy 5 Sessions, Get 1 Free'),
('Knee', 'Whitening Laser', 1299.00, 'Buy 5 Sessions, Get 1 Free'),
('Tattoo Removal', 'Whitening Laser', 1499.00, 'Buy 5 Sessions, Get 1 Free'),
('Full Face', 'HIFU', 14999.00, NULL),
('Partial Face', 'HIFU', 6999.00, NULL),
('Full Face', 'Thermage', 11999.00, NULL),
('Partial Face', 'Thermage', 6999.00, NULL),
('Eye', 'Thermage', 5999.00, NULL),
('Full Face', 'HIFU + Thermage', 25000.00, NULL),
('Half Face', 'HIFU + Thermage', 12000.00, NULL),
('Exosome Facial Stamp', 'Microneedling & RF', 5999.00, NULL),
('Premium RF w/ Exosome', 'Microneedling & RF', 11999.00, NULL),
('Full Face', 'Exilift Ultra 360', 7500.00, 'Buy 5 Sessions, Get 1 Free'),
('Upper Face', 'Exilift Ultra 360', 4500.00, 'Buy 5 Sessions, Get 1 Free'),
('Lower Face', 'Exilift Ultra 360', 4500.00, 'Buy 5 Sessions, Get 1 Free'),
('Neck', 'Exilift Ultra 360', 2000.00, 'Buy 5 Sessions, Get 1 Free'),
('Chin', 'Exilift Ultra 360', 2500.00, 'Buy 5 Sessions, Get 1 Free'),
('Arms', 'Exilift Ultra 360', 2500.00, 'Buy 5 Sessions, Get 1 Free'),
('Back - Butterfly', 'Exilift Ultra 360', 2000.00, 'Buy 5 Sessions, Get 1 Free'),
('Back - Upper', 'Exilift Ultra 360', 2000.00, 'Buy 5 Sessions, Get 1 Free'),
('Back - Lower', 'Exilift Ultra 360', 2000.00, 'Buy 5 Sessions, Get 1 Free'),
('Tummy', 'Exilift Ultra 360', 3000.00, 'Buy 5 Sessions, Get 1 Free'),
('Back & Tummy', 'Exilift Ultra 360', 4000.00, 'Buy 5 Sessions, Get 1 Free'),
('Upper / Lower Lip', 'Diode Laser', 499.00, NULL),
('Underarm - Diode & Whitening Scrub', 'Diode Laser', 1799.00, '+799 Laser Whitening add-on available'),
('Arm - Plain Diode & Whitening Scrub', 'Diode Laser', 2499.00, '+999 Laser Whitening add-on available'),
('Bikini Area with Whitening Scrub', 'Diode Laser', 1499.00, '+599 Laser Whitening add-on available'),
('Legs - Plain Diode & Whitening Scrub', 'Diode Laser', 2799.00, '+1299 Laser Whitening add-on available'),
('Underarm Whitening Scrub', 'Body Scrub', 499.00, NULL),
('Arm Brightening Scrub', 'Body Scrub', 1500.00, NULL),
('Back Brightening Scrub', 'Body Scrub', 1500.00, NULL),
('Legs Brightening Scrub', 'Body Scrub', 1800.00, NULL),
('Face (Unlimited)', 'Warts/Skin Tag/Milia', 1599.00, NULL),
('Neck (Unlimited)', 'Warts/Skin Tag/Milia', 1599.00, NULL),
('Face + Neck', 'Warts/Skin Tag/Milia', 3000.00, NULL),
('Back', 'Warts/Skin Tag/Milia', 1899.00, NULL),
('Chest', 'Warts/Skin Tag/Milia', 1899.00, NULL),
('Back + Chest', 'Warts/Skin Tag/Milia', 3500.00, NULL),
('Genital Warts', 'Warts/Skin Tag/Milia', 2499.00, 'Starts at 2,499'),
('Per Piece Big Warts', 'Warts/Skin Tag/Milia', 2499.00, 'Per area'),
('Syringoma Removal', 'Warts/Skin Tag/Milia', 1499.00, 'Per area'),
('Milia Removal', 'Warts/Skin Tag/Milia', 1499.00, NULL),
('Full Face', 'Botox', 8000.00, NULL),
('Forehead', 'Botox', 5000.00, NULL),
('Crowsfeet', 'Botox', 3500.00, NULL),
('Jawtox', 'Botox', 10000.00, NULL),
('Alartox', 'Botox', 7000.00, NULL),
('Sweatox', 'Botox', 10000.00, NULL),
('Regular Natural Look', 'Eyelash Extension', 400.00, NULL),
('Volume', 'Eyelash Extension', 500.00, NULL);

-- RUN THIS TO REFLECT DATA
-- demo 2 inventory table populating run this on your own device to reflect these thru command prompt
-- ─────────────────────────────────────────────
-- SUPPLIER (INSERT IGNORE protects against duplicate)
-- ─────────────────────────────────────────────
INSERT IGNORE INTO `clinic_supplier` (`supplier_id`, `supplier_name`, `contact_person`, `supplier_contact_number`, `supplier_address`) VALUES
(1, 'Mr. Supplier', 'Mang Tani', '09060585960', 'Over There');

INSERT INTO `clinic_supplier` (`supplier_name`, `contact_person`, `supplier_contact_number`, `supplier_address`) VALUES
('SkinCare Distributors Inc.', 'Ate Maria', '09171234567', 'Tomas Morato, Quezon City');

-- ─────────────────────────────────────────────
-- INVENTORY SHIPMENTS
-- ─────────────────────────────────────────────
INSERT INTO `clinic_inventoryshipment` (`received_product_name`, `date_received`, `supplier_id`, `branch_id`) VALUES
('Esthetmax Jelly Mask', '2025-10-05', 1, 1),
('Special Mask',         '2025-10-18', 1, 1),
('Jelly Mask',           '2025-11-03', 1, 1),
('Gold Mask',            '2025-11-20', 1, 1),
('Extraction',           '2025-12-02', 1, 1),
('Ear Gun Piercing',     '2025-12-15', 1, 1),
('Keloid Injection',     '2026-01-08', 1, 1),
('Acne Shot',            '2026-01-22', 1, 1),
('Topical Anesthesia',   '2026-03-01', 1, 1);

-- ─────────────────────────────────────────────
-- RECEIVED PRODUCTS
-- ─────────────────────────────────────────────
INSERT INTO `clinic_receivedproduct` (`inventory_record_id`, `product_id`, `quantity_received`, `expiration_date`, `branch_id`) VALUES
(8,  1,  100, '2027-10-05', 1),
(9,  2,   50, '2027-10-18', 1),
(10, 3,  100, '2027-11-03', 1),
(11, 4,   50, '2027-11-20', 1),
(12, 5,  100, '2027-12-02', 1),
(13, 6,   50, '2027-12-15', 1),
(14, 7,  100, '2028-01-08', 1),
(15, 8,   50, '2028-01-22', 1),
(16, 10,  50, '2028-03-01', 1);

-- ─────────────────────────────────────────────
-- BRANCH PRODUCT STOCK
-- ─────────────────────────────────────────────
INSERT IGNORE INTO `clinic_branchproduct` (`branch_id`, `product_id`, `stock_quantity`, `quantity_minimum`) VALUES
(1,  1, 100, 10),
(1,  2,  50, 10),
(1,  3, 100, 10),
(1,  4,  50, 10),
(1,  5, 100, 10),
(1,  6,  50, 10),
(1,  7, 100, 10),
(1, 10,  50, 10);

-- ─────────────────────────────────────────────
-- INVENTORY SHIPMENTS (IDs 17-21)
-- ─────────────────────────────────────────────
INSERT INTO `clinic_inventoryshipment` (`received_product_name`, `date_received`, `supplier_id`, `branch_id`) VALUES
('Cleansing Solution (150ml)',  '2026-01-10', 1, 1),
('Clarifying Solution (60ml)',  '2026-01-15', 1, 1),
('Body Astringent (150ml)',     '2026-02-01', 1, 1),
('Brightening Soap (90g)',      '2026-02-15', 1, 1),
('Bleaching Soap (90g)',        '2026-03-01', 1, 1);

-- ─────────────────────────────────────────────
-- RECEIVED PRODUCTS
-- ─────────────────────────────────────────────
INSERT INTO `clinic_receivedproduct` (`inventory_record_id`, `product_id`, `quantity_received`, `expiration_date`, `branch_id`) VALUES
(17, 29, 100, '2027-01-10', 1),
(18, 30, 100, '2027-01-15', 1),
(19, 33, 100, '2027-02-01', 1),
(20, 34, 100, '2027-02-15', 1),
(21, 35, 100, '2027-03-01', 1);

-- ─────────────────────────────────────────────
-- BRANCH PRODUCT STOCK
-- ─────────────────────────────────────────────
INSERT IGNORE INTO `clinic_branchproduct` (`branch_id`, `product_id`, `stock_quantity`, `quantity_minimum`) VALUES
(1, 29, 100, 10),
(1, 30, 100, 10),
(1, 33, 100, 10),
(1, 34, 100, 10),
(1, 35, 100, 10);

-- ─────────────────────────────────────────────
-- UPDATE BRANCH NAME
-- ─────────────────────────────────────────────
UPDATE `clinic_clinicbranch` SET `branch_location` = 'Meycauayan, Bulacan' WHERE `branch_id` = 1;