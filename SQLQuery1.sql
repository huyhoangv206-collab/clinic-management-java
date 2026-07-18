CREATE DATABASE [Dental];
GO

USE [Dental];
GO

-- 1. Table: roles
CREATE TABLE roles (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name NVARCHAR(50) NOT NULL
);

-- Insert roles
INSERT INTO roles (role_name) VALUES
('ADMIN'),
('DOCTOR'),
('STAFF'),
('CUSTOMER');

-- 2. Table: users
CREATE TABLE users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL, -- email usually doesn't need N, but just to be safe or leave as VARCHAR
    password NVARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role_id INT,
    gender NVARCHAR(10),
    dob DATE,
    address NVARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    display_order INT,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Fix email MVARCHAR typo, email is VARCHAR
-- 3. Table: services
CREATE TABLE services (
    service_id INT PRIMARY KEY IDENTITY(1,1),
    service_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    duration_minutes INT 
);

-- 4. Table: appointments
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY IDENTITY(1,1),
    patient_id INT, 
    doctor_id INT,  
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status NVARCHAR(50) DEFAULT 'Pending', 
    notes NVARCHAR(MAX),
    room NVARCHAR(50), 
    is_checked_in BIT DEFAULT 0,
    is_checked_out BIT DEFAULT 0,
    is_completed BIT DEFAULT 0,
    is_in_room BIT DEFAULT 0,
    is_successful BIT DEFAULT 0,
    FOREIGN KEY (patient_id) REFERENCES users(user_id),
    FOREIGN KEY (doctor_id) REFERENCES users(user_id)
);

-- 5. Table: appointment_services
CREATE TABLE appointment_services (
    appointment_id INT,
    service_id INT,
    PRIMARY KEY (appointment_id, service_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- 6. Table: examination_results
CREATE TABLE examination_results (
    result_id INT PRIMARY KEY IDENTITY(1,1),
    appointment_id INT UNIQUE,
    result_details NVARCHAR(MAX), 
    examination_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- 7. Table: prescribed_services
CREATE TABLE prescribed_services (
    result_id INT,
    service_id INT,
    status NVARCHAR(50) DEFAULT 'Pending', 
    notes NVARCHAR(MAX),
    PRIMARY KEY (result_id, service_id),
    FOREIGN KEY (result_id) REFERENCES examination_results(result_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- 8. Table: prescriptions
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY IDENTITY(1,1),
    result_id INT UNIQUE,
    instructions NVARCHAR(MAX), 
    FOREIGN KEY (result_id) REFERENCES examination_results(result_id)
);

-- 9. Table: medicines
CREATE TABLE medicines (
    medicine_id INT PRIMARY KEY IDENTITY(1,1),
    medicine_name NVARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL 
);

-- 10. Table: prescription_details
CREATE TABLE prescription_details (
    prescription_id INT,
    medicine_id INT,
    prescribed_quantity INT NOT NULL, 
    purchased_quantity INT DEFAULT 0, 
    unit_price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (prescription_id, medicine_id),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id),
    FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
);

-- 11. Table: clinic_configs
CREATE TABLE clinic_configs (
    config_id INT PRIMARY KEY IDENTITY(1,1),
    opening_time TIME,
    closing_time TIME,
    clinic_info NVARCHAR(MAX)
);
GO
USE [Dental];
GO

-- =======================================================================
-- 1. CHÈN DỮ LIỆU BẢNG: users
-- Quy ước role_id: 1 = ADMIN, 2 = DOCTOR, 3 = STAFF, 4 = CUSTOMER
-- =======================================================================
INSERT INTO users (full_name, email, password, phone, role_id, gender, dob, address, display_order) VALUES
(N'Nguyễn Minh Admin', 'admin@dental.com', 'admin123', '0901234567', 1, N'Nam', '1990-05-15', N'123 Đường Lê Lợi, Quận 1, TP.HCM', 1),
(N'Bác sĩ Trần Gia Bảo', 'dr.bao@dental.com', 'doctor123', '0912345678', 2, N'Nam', '1985-08-20', N'456 Đường Nguyễn Huệ, Quận 1, TP.HCM', 2),
(N'Bác sĩ Lê Thị Mai', 'dr.mai@dental.com', 'doctor123', '0923456789', 2, N'Nữ', '1988-11-12', N'789 Đường Cách Mạng Tháng 8, Quận 3, TP.HCM', 3),
(N'Lễ tân Phạm Mỹ Linh', 'linh.staff@dental.com', 'staff123', '0934567890', 3, N'Nữ', '1995-02-25', N'321 Đường Võ Văn Tần, Quận 3, TP.HCM', 4),
(N'Khách hàng Lê Văn Đạt', 'dat.customer@gmail.com', 'customer123', '0987654321', 4, N'Nam', '1998-04-05', N'12 Đường số 4, Bình Tân, TP.HCM', 99),
(N'Khách hàng Hoàng Thu Thủy', 'thuy.customer@gmail.com', 'customer123', '0976543210', 4, N'Nữ', '2000-09-30', N'56 Đường Lê Văn Sỹ, Tân Bình, TP.HCM', 99);


-- =======================================================================
-- 2. CHÈN DỮ LIỆU BẢNG: services (Dịch vụ nha khoa)
-- =======================================================================
INSERT INTO services (service_name, description, price, duration_minutes) VALUES
(N'Cạo vôi răng & Đánh bóng', N'Làm sạch mảng bám và cao răng bằng sóng siêu âm', 300000.00, 30),
(N'Trám răng thẩm mỹ', N'Trám composite các lỗ sâu răng nhẹ bằng công nghệ hiện đại', 400000.00, 45),
(N'Tẩy trắng răng Laser White', N'Tẩy trắng răng nhanh tại phòng khám bằng ánh sáng Laser', 2500000.00, 60),
(N'Nhổ răng khôn (Răng số 8)', N'Phẫu thuật tiểu phẫu nhổ răng khôn mọc lệch, mọc ngầm', 1500000.00, 45);


-- =======================================================================
-- 3. CHÈN DỮ LIỆU BẢNG: medicines (Thuốc)
-- =======================================================================
INSERT INTO medicines (medicine_name, price, stock_quantity) VALUES
(N'Paracetamol 500mg (Giảm đau)', 2000.00, 500),
(N'Amoxicillin 500mg (Kháng sinh)', 3500.00, 300),
(N'Ibuprofen 400mg (Giảm đau kháng viêm)', 2500.00, 200),
(N'Nước súc miệng diệt khuẩn Kin', 120000.00, 50);


-- =======================================================================
-- 4. CHÈN DỮ LIỆU BẢNG: clinic_configs (Cấu hình phòng khám)
-- =======================================================================
INSERT INTO clinic_configs (opening_time, closing_time, clinic_info) VALUES
('08:00:00', '20:00:00', N'Nha Khoa Quốc Tế Dental - Hotline: 19001234');


-- =======================================================================
-- 5. CHÈN DỮ LIỆU BẢNG: appointments (Lịch hẹn khám)
-- Kết nối: patient_id = 5 (Đạt), doctor_id = 2 (Bác sĩ Bảo)
-- =======================================================================
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, notes, room, is_checked_in, is_in_room, is_checked_out, is_completed, is_successful) VALUES
(5, 2, CAST(GETDATE() AS DATE), '09:00:00', 'CONFIRMED', N'Bệnh nhân đau răng buốt khi uống nước lạnh', N'Phòng Khám Số 1', 1, 1, 0, 0, 0),
(6, 3, CAST(DATEADD(day, 1, GETDATE()) AS DATE), '14:30:00', 'Pending', N'Đăng ký lịch tẩy trắng răng', N'Phòng Khám Số 2', 0, 0, 0, 0, 0);


-- =======================================================================
-- 6. CHÈN DỮ LIỆU BẢNG: appointment_services (Dịch vụ trong lịch hẹn)
-- Lịch hẹn 1 chọn dịch vụ Trám răng (service_id = 2)
-- Lịch hẹn 2 chọn dịch vụ Tẩy trắng răng (service_id = 3)
-- =======================================================================
INSERT INTO appointment_services (appointment_id, service_id) VALUES 
(1, 2),
(2, 3);


-- =======================================================================
-- 7. CHÈN DỮ LIỆU BẢNG: examination_results (Kết quả khám cho lịch hẹn số 1)
-- =======================================================================
INSERT INTO examination_results (appointment_id, result_details) VALUES
(1, N'Răng số 36 bị sâu men, đã tiến hành nạo sạch vết sâu và trám lại bằng Composite.');


-- =======================================================================
-- 8. CHÈN DỮ LIỆU BẢNG: prescribed_services (Dịch vụ bác sĩ chỉ định thêm sau khi khám)
-- Sau khi khám kết quả 1, bác sĩ chỉ định làm thêm dịch vụ Cạo vôi răng (service_id = 1)
-- =======================================================================
INSERT INTO prescribed_services (result_id, service_id, status, notes) VALUES
(1, 1, 'Completed', N'Thực hiện cạo vôi răng luôn sau khi trám xong');


-- =======================================================================
-- 9. CHÈN DỮ LIỆU BẢNG: prescriptions (Đơn thuốc)
-- Kê đơn thuốc dựa trên kết quả khám số 1
-- =======================================================================
INSERT INTO prescriptions (result_id, instructions) VALUES
(1, N'Uống thuốc sau khi ăn no, súc miệng nước Kin ngày 3 lần.');


-- =======================================================================
-- 10. CHÈN DỮ LIỆU BẢNG: prescription_details (Chi tiết đơn thuốc)
-- Đơn thuốc số 1 gồm: Paracetamol (id 1, kê 10 viên, mua cả 10) và Nước súc miệng (id 4, kê 1 chai, mua 1)
-- =======================================================================
INSERT INTO prescription_details (prescription_id, medicine_id, prescribed_quantity, purchased_quantity, unit_price) VALUES
(1, 1, 10, 10, 2000.00),
(1, 4, 1, 1, 120000.00);
GO




USE [Dental];
GO

-- 1. Cập nhật lại mật khẩu cho tài khoản Admin đã có sẵn thành 'admin'
UPDATE users 
SET password = 'admin' 
WHERE email = 'admin@dental.com';

-- 2. Chèn thêm 3 tài khoản mới (Bác sĩ, Nhân viên, Khách hàng)
-- Quy ước role_id: 2 = DOCTOR, 3 = STAFF, 4 = CUSTOMER
INSERT INTO users (full_name, email, password, phone, role_id, gender, dob, address, display_order) VALUES
(N'Bác sĩ Nguyễn Văn A', 'doctor1@dental.com', '123', '0911223344', 2, N'Nam', '1987-01-01', N'Địa chỉ Bác sĩ', 5),
(N'Nhân viên Độ Mixi', 'domixue@gmail.com', '123', '0922334455', 3, N'Nam', '1989-09-12', N'Cao Bằng', 6),
(N'Khách hàng Nguyễn Hùng', 'hung@gmail.com', '123', '0933445566', 4, N'Nam', '1995-05-20', N'Địa chỉ Khách hàng', 99);
GO