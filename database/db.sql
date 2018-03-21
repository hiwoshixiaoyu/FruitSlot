-- --------------------------------------------------------
-- 主机:                           127.0.0.1
-- 服务器版本:                        5.7.20 - MySQL Community Server (GPL)
-- 服务器操作系统:                      Win64
-- HeidiSQL 版本:                  9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
-- 正在导出表  test.fruitslot 的数据：~31 rows (大约)
DELETE FROM `fruitslot`;
/*!40000 ALTER TABLE `fruitslot` DISABLE KEYS */;
INSERT INTO `fruitslot` (`No`, `name`, `id`, `start`, `end`, `gailv`) VALUES
	(1, '大铃铛', 0, 1, 50, 0),
	(2, '小bar', 1, 51, 100, 0),
	(3, '大bar', 2, 101, 110, 0),
	(4, '大苹果', 3, 111, 130, 0),
	(5, '小苹果', 4, 131, 180, 0),
	(6, '大芒果', 5, 181, 199, 0),
	(7, '大西瓜', 6, 200, 220, 0),
	(8, '小西瓜', 7, 221, 250, 0),
	(9, '大苹果', 9, 251, 300, 0),
	(10, '小橘子', 10, 301, 350, 0),
	(11, '大橘子', 11, 351, 400, 0),
	(12, '大铃铛', 12, 401, 440, 0),
	(13, '小77', 13, 441, 450, 0),
	(14, '大77', 14, 451, 500, 0),
	(15, '大苹果', 15, 501, 550, 0),
	(16, '小芒果', 16, 551, 600, 0),
	(17, '大芒果', 17, 601, 650, 0),
	(18, '大双星', 18, 651, 700, 0),
	(19, '小双星', 19, 701, 750, 0),
	(20, '大苹果', 21, 751, 799, 0),
	(21, '小铃铛', 22, 800, 869, 0),
	(22, '大橘子', 23, 870, 899, 0),
	(23, '小三元', 8, 900, 919, 0),
	(24, '大三元', 20, 920, 929, 0),
	(25, '小四喜', 8, 930, 939, 0),
	(26, '大四喜', 20, 940, 949, 0),
	(27, '小满贯', 8, 950, 959, 0),
	(28, '大满贯', 20, 960, 969, 0),
	(29, '开火车', 20, 970, 979, 0),
	(30, 'over', 20, 980, 989, 0),
	(31, 'over', 20, 990, 1000, 0);
/*!40000 ALTER TABLE `fruitslot` ENABLE KEYS */;

-- 正在导出表  test.gm 的数据：~1 rows (大约)
DELETE FROM `gm`;
/*!40000 ALTER TABLE `gm` DISABLE KEYS */;
INSERT INTO `gm` (`uuid`) VALUES
	('asd123');
/*!40000 ALTER TABLE `gm` ENABLE KEYS */;

-- 正在导出表  test.player 的数据：~3 rows (大约)
DELETE FROM `player`;
/*!40000 ALTER TABLE `player` DISABLE KEYS */;
INSERT INTO `player` (`username`, `pwd`, `uuid`, `gold`, `zuanshi`) VALUES
	('testusername', '123456', 'uuid', 1060, 10),
	('testus3ername', '123456', 'uuid', 1060, 10),
	('test', '123456', 'uuid', 2076, 10);
/*!40000 ALTER TABLE `player` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
