-- Cyber Monitoring Database
DROP DATABASE IF EXISTS cyber_monitoring;
CREATE DATABASE cyber_monitoring CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cyber_monitoring;

CREATE TABLE users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50) NOT NULL UNIQUE,
    full_name  VARCHAR(100),
    role       ENUM('admin','operator','viewer') NOT NULL DEFAULT 'viewer',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE hosts (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    hostname   VARCHAR(100) NOT NULL UNIQUE,
    ip_address VARCHAR(45),
    os         VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE metrics (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    host_id       INT NOT NULL,
    measured_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cpu_load      DECIMAL(5,2),
    mem_used_mb   INT,
    disk_used_pct TINYINT UNSIGNED,
    CONSTRAINT fk_metrics_host FOREIGN KEY (host_id) REFERENCES hosts(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE events (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    host_id    INT,
    user_id    INT,
    level      ENUM('INFO','WARNING','ERROR','CRITICAL') NOT NULL DEFAULT 'INFO',
    message    TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_events_host FOREIGN KEY (host_id) REFERENCES hosts(id) ON DELETE SET NULL,
    CONSTRAINT fk_events_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

INSERT INTO users (username, full_name, role) VALUES
    ('adylbek','Адылбек','admin'),
    ('operator1','Оператор смены','operator'),
    ('guest','Гостевой доступ','viewer');

INSERT INTO hosts (hostname, ip_address, os) VALUES
    ('WIN-NJPSMHUT7D0','192.168.1.10','Ubuntu 24.04 (WSL2)'),
    ('srv-web-01','192.168.1.20','Ubuntu Server 24.04');

INSERT INTO metrics (host_id, cpu_load, mem_used_mb, disk_used_pct) VALUES
    (1,0.35,842,37), (1,0.52,910,37), (2,1.24,2048,64);

INSERT INTO events (host_id, user_id, level, message) VALUES
    (1,1,'INFO','Cyber Monitoring started'),
    (1,2,'WARNING','Загрузка диска превысила 35%'),
    (2,NULL,'ERROR','Хост не отвечает более 60 секунд');
