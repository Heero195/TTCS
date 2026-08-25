TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER checkImportToolDateInsert\nBEFORE INSERT ON DUNGCU\nFOR EACH ROW\nBEGIN\n    IF NEW.NgayNhap >= NEW.HanSuDung THEN\n        SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'Ngày nhập phải nhỏ hơn hạn sử dụng!\';\n    END IF;\nEND' 'CREATE DEFINER=`root`@`localhost` TRIGGER checkImportToolDateUpdate\nBEFORE INSERT ON DUNGCU\nFOR EACH ROW\nBEGIN\n    IF NEW.NgayNhap >= NEW.HanSuDung THEN\n        SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'Ngày nhập phải nhỏ hơn hạn sử dụng!\';\n    END IF;\nEND'
sql_modes=524288 524288
definers='root@localhost' 'root@localhost'
client_cs_names='utf8mb4' 'utf8mb4'
connection_cl_names='utf8mb4_unicode_ci' 'utf8mb4_unicode_ci'
db_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci'
created=1762245497490473 1762245497519400
