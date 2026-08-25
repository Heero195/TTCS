TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER modifyRoom AFTER UPDATE ON PHONG\nFOR EACH ROW\nBEGIN\n    DECLARE v_so_luong_BN_nhap_vien INT;\n\n    SELECT COUNT(*) INTO v_so_luong_BN_nhap_vien\n    FROM BENHNHAN\n    WHERE MaP = OLD.MaP;\n\n    IF v_so_luong_BN_nhap_vien > NEW.SoLuongBNToiDa THEN\n        SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'SỐ LƯỢNG BỆNH NHÂN LỚN HƠN SỨC CHỨA CỦA PHÒNG\';\n    END IF;\nEND'
sql_modes=524288
definers='root@localhost'
client_cs_names='utf8mb4'
connection_cl_names='utf8mb4_unicode_ci'
db_cl_names='utf8mb4_general_ci'
created=1762245497455958
