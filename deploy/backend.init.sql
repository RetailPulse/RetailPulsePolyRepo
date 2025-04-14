-- MySQL dump 10.13  Distrib 9.2.0, for Linux (x86_64)
--
-- Host: localhost    Database: RetailPulseDB
-- ------------------------------------------------------
-- Server version	9.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `business_entity`
--

DROP TABLE IF EXISTS `business_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_entity` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `external` bit(1) NOT NULL,
  `location` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_entity`
--

LOCK TABLES `business_entity` WRITE;
/*!40000 ALTER TABLE `business_entity` DISABLE KEYS */;
INSERT INTO `business_entity` VALUES (1,_binary '',_binary '\0','Woodlands','CausewayPoint','Shop'),(2,_binary '',_binary '\0','Punggol','Waterway Point','Shop'),(3,_binary '',_binary '\0','Tuas','Main Warehouse','CentralInventory'),(4,_binary '',_binary '','Tuas','Ah Hock Pte Ltd','Supplier');
/*!40000 ALTER TABLE `business_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `business_entity_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `quantity` int NOT NULL,
  `total_cost_price` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,3,6,100,0),(2,3,4,100,0),(3,3,2,100,0),(4,3,5,100,0),(5,3,3,100,0),(6,3,1,100,0),(7,3,9,100,0),(8,3,7,100,0),(9,3,12,100,0),(10,3,10,100,0),(11,3,13,100,0),(12,3,8,100,0),(13,3,14,100,0),(14,3,16,100,0),(15,3,18,100,0),(16,3,17,100,0),(17,3,19,100,0),(18,3,15,100,0),(19,3,20,100,0),(20,3,23,100,0),(21,3,24,100,0),(22,3,21,100,0),(23,3,25,100,0),(24,3,22,100,0),(25,3,26,100,0),(26,3,27,100,0),(27,3,29,100,0),(28,3,31,100,0),(29,3,30,100,0),(30,3,28,100,0),(31,3,32,100,0),(32,3,33,100,0),(33,3,34,100,0),(34,3,36,100,0),(35,3,35,100,0);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_transaction`
--

DROP TABLE IF EXISTS `inventory_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_transaction` (
  `id` binary(16) NOT NULL,
  `cost_price_per_unit` double NOT NULL,
  `destination` bigint NOT NULL,
  `inserted_at` datetime(6) NOT NULL,
  `product_id` bigint NOT NULL,
  `quantity` int NOT NULL,
  `source` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_transaction`
--

LOCK TABLES `inventory_transaction` WRITE;
/*!40000 ALTER TABLE `inventory_transaction` DISABLE KEYS */;
INSERT INTO `inventory_transaction` VALUES (_binary ':\öWG‡°a\ó\âÿ¦',0,3,'2025-04-14 15:44:14.222154',9,100,4),(_binary '\r\×\õ\õ\Õ_@Õ†¯«wx\õ\Ê9',0,3,'2025-04-14 15:44:14.293176',18,100,4),(_binary ':_¯œLÉ²m§\Ó)I\â',0,3,'2025-04-14 15:44:14.354493',24,100,4),(_binary 'f\îK\Ú\ìK´F…„­»Q',0,3,'2025-04-14 15:44:14.136052',2,100,4),(_binary '\å\Ñ\Z¢Dm²¨¿\è\ÜK;',0,3,'2025-04-14 15:44:14.136051',3,100,4),(_binary '\ZˆE†”5Cˆ—E\Ä\÷Šú¡®',0,3,'2025-04-14 15:44:14.286405',14,100,4),(_binary '\Ê\äš,C‘–\\\ï¥y',0,3,'2025-04-14 15:44:14.293178',16,100,4),(_binary '$]¢Æ­J†7œV\ÅY{',0,3,'2025-04-14 15:44:14.354493',21,100,4),(_binary '2°\êˆ”K\\¾\Ü*\öu\ï',0,3,'2025-04-14 15:44:14.350288',20,100,4),(_binary '?k_»ÿD™7\ÇK\ñ\'',0,3,'2025-04-14 15:44:14.423610',28,100,4),(_binary 'G\â\Úhe6NÏ©fø;\Ş\Ø;',0,3,'2025-04-14 15:44:14.481959',33,100,4),(_binary 'QN\õ`)²NVˆ*²…¬2',0,3,'2025-04-14 15:44:14.227492',10,100,4),(_binary 'k\æ^zWO[œY\Ìs¿Tø',0,3,'2025-04-14 15:44:14.354583',25,100,4),(_binary 'tT¦\Ô®NŒü[E_D,À',0,3,'2025-04-14 15:44:14.489975',36,100,4),(_binary 'v‡nÿWFÀ¯¨‹¿Â¬¨B',0,3,'2025-04-14 15:44:14.293176',19,100,4),(_binary 'zÜ©c\n\ĞBDˆ­\Â9-A=',0,3,'2025-04-14 15:44:14.455791',32,100,4),(_binary 'ÖœLf N˜-Y2\Ä\ê',0,3,'2025-04-14 15:44:14.354550',23,100,4),(_binary '‚>\åU\öºI½\ñH+\ñy',0,3,'2025-04-14 15:44:14.226998',12,100,4),(_binary 'ƒİ¸)=¨A&“\×q)	cF',0,3,'2025-04-14 15:44:14.136051',5,100,4),(_binary 'Š¡²†\Â@]²•†€\ŞX\ò¾',0,3,'2025-04-14 15:44:14.423385',30,100,4),(_binary 'µ\Û°€OÍ %{\×\÷ªøO',0,3,'2025-04-14 15:44:14.481959',34,100,4),(_binary '›6–)\îÀAs¯,™(\Ûu',0,3,'2025-04-14 15:44:14.136062',6,100,4),(_binary '¡†x\å–\öB\à—°G İ‰§',0,3,'2025-04-14 15:44:14.399623',26,100,4),(_binary '§]¸\Ì\ìGm·=£\Ñ\Æù[',0,3,'2025-04-14 15:44:14.423279',31,100,4),(_binary 'Ç¼§~X\ÒJ²¥f${¢ \Ñ',0,3,'2025-04-14 15:44:14.227005',7,100,4),(_binary 'ÑˆbWWN­<\nªû\ã',0,3,'2025-04-14 15:44:14.136052',1,100,4),(_binary 'Ùƒ— \'MKı¹\0vt\ÜÙ¶X',0,3,'2025-04-14 15:44:14.226998',13,100,4),(_binary '\à\'½ag\ãBÕ¬8º\Óç±£',0,3,'2025-04-14 15:44:14.354624',22,100,4),(_binary '\à]C®WO\ñ‚\õO\Ô\Ğ=P+',0,3,'2025-04-14 15:44:14.293185',15,100,4),(_binary '\ò§{@S\ÓF©´bŠ¦:°',0,3,'2025-04-14 15:44:14.489974',35,100,4),(_binary '\ô\äJ£\õFC¶€\ôµ\Ó\İLv½',0,3,'2025-04-14 15:44:14.423402',29,100,4),(_binary '\ôç‹½¸EÌ·¡\ÛÇ§ÿÂ‚',0,3,'2025-04-14 15:44:14.136055',4,100,4),(_binary '\ö\Ş¾—IM„…71(‡\×\r',0,3,'2025-04-14 15:44:14.414086',27,100,4),(_binary '\÷ÿŞ—AÀ´Ë° \"',0,3,'2025-04-14 15:44:14.293176',17,100,4),(_binary 'û0uh\ÛmB ‘ eü]\ìœ',0,3,'2025-04-14 15:44:14.227012',8,100,4);
/*!40000 ALTER TABLE `inventory_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `origin` varchar(255) DEFAULT NULL,
  `rrp` double NOT NULL,
  `sku` varchar(255) NOT NULL,
  `subcategory` varchar(255) DEFAULT NULL,
  `uom` varchar(255) DEFAULT NULL,
  `vendor_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKq1mafxn973ldq80m1irp3mpvq` (`sku`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,_binary '','LEV-M-0001','LEVIS','Men','Authentic Button-Down Shirt','USA',99.9,'RP1','Top','Piece','LEV'),(2,_binary '','LEV-M-0002','LEVIS','Men','Sunset Pocket Standard Fit Shirt','USA',94.9,'RP2','Top','Piece','LEV'),(3,_binary '','LEV-M-0003','LEVIS','Men','Classic Pocket Standard Fit Shirt','USA',66.4,'RP3','Top','Piece','LEV'),(4,_binary '','LEV-M-0004','LEVIS','Men','Short-Sleeve Banded Collar Shirt','USA',84.9,'RP4','Top','Piece','LEV'),(5,_binary '','LEV-M-0005','LEVIS','Men','Classic Western Standard Fit Shirt','USA',104.9,'RP5','Top','Piece','LEV'),(6,_binary '','LEV-M-1001','LEVIS','Men','502 Taper Jeans','USA',109.9,'RP6','Jeans','Piece','LEV'),(7,_binary '','LEV-M-1002','LEVIS','Men','501 Original Lightweight Jeans','USA',129.9,'RP7','Jeans','Piece','LEV'),(8,_binary '','LEV-M-1003','LEVIS','Men','55 Relaxed Straight Lightweight Jeans','USA',159.9,'RP8','Jeans','Piece','LEV'),(9,_binary '','LEV-M-1004','LEVIS','Men','Blue Tab Men\'s 511 Slim Jeans','USA',349.9,'RP9','Jeans','Piece','LEV'),(10,_binary '','LEV-M-1005','LEVIS','Men','555 Relaxed Straight Jeans','USA',89.9,'RP10','Jeans','Piece','LEV'),(12,_binary '','LEV-F-0001','LEVIS','Women','Harlie Boyfriend Shirt','USA',89.9,'RP11','Top','Piece','LEV'),(13,_binary '','LEV-F-0002','LEVIS','Women','Mandy Long-Sleeve Blouse','USA',89.9,'RP12','Top','Piece','LEV'),(14,_binary '','LEV-F-0003','LEVIS','Women','Winona Shirt','USA',99.9,'RP13','Top','Piece','LEV'),(15,_binary '','LEV-F-0004','LEVIS','Women','Blue Tab Tuxedo Shirt','USA',199.9,'RP14','Top','Piece','LEV'),(16,_binary '','LEV-F-0005','LEVIS','Women','Darlene Utility Shirt','USA',89.9,'RP15','Top','Piece','LEV'),(17,_binary '','LEV-F-1001','LEVIS','Women','Ribcage Wide Leg Jeans','USA',149.9,'RP16','Jeans','Piece','LEV'),(18,_binary '','LEV-F-1002','LEVIS','Women','Blue Tab Plank Straight Jeans','USA',299.9,'RP17','Jeans','Piece','LEV'),(19,_binary '','LEV-F-1003','LEVIS','Women','Blue Tab Column Jeans','USA',349.9,'RP18','Jeans','Piece','LEV'),(20,_binary '','LEV-F-2001','LEVIS','Women','Icon Skirt','USA',79.9,'RP19','Skirt','Piece','LEV'),(21,_binary '','LEV-F-2002','LEVIS','Women','High-Rise Slit Skirt','USA',94.9,'RP20','Skirt','Piece','LEV'),(22,_binary '','LEV-F-8001','LEVIS','Women','Heritage Tote-All Bag','USA',59.9,'RP21','Bag','Piece','LEV'),(23,_binary '','LEV-F-8002','LEVIS','Women','Brooklyn XL Shoulder Bag','USA',89.9,'RP22','Bag','Piece','LEV'),(24,_binary '','LEV-F-8003','LEVIS','Women','Devon Crossbody Bag','USA',34.9,'RP23','Bag','Piece','LEV'),(25,_binary '','LEV-M-8001','LEVIS','Men','Icon Tote','USA',59.9,'RP24','Bag','Piece','LEV'),(26,_binary '','LEV-M-8002','LEVIS','Men','Heritage Messenger Bag','USA',54.9,'RP25','Bag','Piece','LEV'),(27,_binary '','DIE-M-1001','DIESEL','Men','1986 Larkee-Beex 009ZS','Italy',300,'RP26','Jeans','Piece','DIE'),(28,_binary '','DIE-M-1002','DIESEL','Men','2023 D-Finitive 09l23','Italy',480,'RP27','Jeans','Piece','DIE'),(29,_binary '','DIE-M-1003','DIESEL','Men','Regular 2030 D-Krooley Joggjeans 0670m','Italy',590,'RP28','Jeans','Piece','DIE'),(30,_binary '','DIE-U-0001','DIESEL','Unisex','S-Leon: Fluid crinkled shirt with logo collar','Italy',590,'RP29','Top','Piece','DIE'),(31,_binary '','DIE-M-0001','DIESEL','Men','S-Elly: Faded bowling shirt with logo prints','Italy',480,'RP30','Top','Piece','DIE'),(32,_binary '','DIE-M-0002','DIESEL','Men','S-Simply-Dnm: Shirt in cotton poplin and denim','Italy',535,'RP31','Top','Piece','DIE'),(33,_binary '','LEV-U-0002','DIESEL','Unisex','D-Giri-S Track: Zipped hoodie in dirt-effect Track Denim','Italy',630,'RP32','Top','Piece','DIE'),(34,_binary '','DIE-F-0001','DIESEL','Women','F-Slimmy-Hood-Od','Italy',480,'RP33','Top','Piece','DIE'),(35,_binary '','DIE-F-0002','DIESEL','Women','T-Ele: Ribbed T-shirt with watercolour heart D','Italy',143,'RP34','Top','Piece','DIE'),(36,_binary '','DIE-F-0003','DIESEL','Women','T-Uncuties-Short-Q2: T-shirt with Diesel Core logo','Italy',180,'RP35','Top','Piece','DIE');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_details`
--

DROP TABLE IF EXISTS `sales_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_details` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `quantity` int NOT NULL,
  `sales_price_per_unit` decimal(38,2) NOT NULL,
  `sale_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKmofh1590bbm744ll9r3aywtk` (`sale_id`),
  CONSTRAINT `FKmofh1590bbm744ll9r3aywtk` FOREIGN KEY (`sale_id`) REFERENCES `sales_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_details`
--

LOCK TABLES `sales_details` WRITE;
/*!40000 ALTER TABLE `sales_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_tax`
--

DROP TABLE IF EXISTS `sales_tax`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_tax` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tax_rate` decimal(38,2) DEFAULT NULL,
  `tax_type` enum('GST') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_tax`
--

LOCK TABLES `sales_tax` WRITE;
/*!40000 ALTER TABLE `sales_tax` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_tax` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_transaction`
--

DROP TABLE IF EXISTS `sales_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_transaction` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `business_entity_id` bigint NOT NULL,
  `sales_tax_amount` decimal(38,2) DEFAULT NULL,
  `subtotal` decimal(38,2) DEFAULT NULL,
  `total` decimal(38,2) DEFAULT NULL,
  `transaction_date` datetime(6) NOT NULL,
  `sales_tax_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7wq54e1ubjodfnaph9fu12grq` (`sales_tax_id`),
  CONSTRAINT `FK7wq54e1ubjodfnaph9fu12grq` FOREIGN KEY (`sales_tax_id`) REFERENCES `sales_tax` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_transaction`
--

LOCK TABLES `sales_transaction` WRITE;
/*!40000 ALTER TABLE `sales_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skucounter`
--

DROP TABLE IF EXISTS `skucounter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skucounter` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `counter` bigint DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK7owhpmjg2da0234khrv8rk479` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skucounter`
--

LOCK TABLES `skucounter` WRITE;
/*!40000 ALTER TABLE `skucounter` DISABLE KEYS */;
INSERT INTO `skucounter` VALUES (1,35,'product');
/*!40000 ALTER TABLE `skucounter` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-14 15:49:33
