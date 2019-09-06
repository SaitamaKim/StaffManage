/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80013
 Source Host           : localhost:3308
 Source Schema         : staff

 Target Server Type    : MySQL
 Target Server Version : 80013
 File Encoding         : 65001

 Date: 06/09/2019 15:40:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `account` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `phone` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gender` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`account`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('1001', '金虎', '123123123', '18851762510', '男');
INSERT INTO `admin` VALUES ('1002', '方家璇', '123123123', '18812341233', '男');
INSERT INTO `admin` VALUES ('1003', '覃炳荣', '123123123', '18851782312', '男');

-- ----------------------------
-- Table structure for chief
-- ----------------------------
DROP TABLE IF EXISTS `chief`;
CREATE TABLE `chief`  (
  `account` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gender` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `department` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `phone` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`account`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chief
-- ----------------------------
INSERT INTO `chief` VALUES ('2001', '主管A', '123123123', '男', '部门A', '12324123');
INSERT INTO `chief` VALUES ('2002', '主管B', '123123123', '女', '部门B', '213123');
INSERT INTO `chief` VALUES ('2003', '主管boy', '123123123', '男', '部门C', '123124312');
INSERT INTO `chief` VALUES ('2004', '主管boy', '123123124', '男', '部门C', '123124313');
INSERT INTO `chief` VALUES ('2005', '主管girl', '123123125', '女', '部门C', '123124314');

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `account` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '123123123',
  `department` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `performance` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`account`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES ('3001', '员工A', '123123123', '部门A', '123123123');
INSERT INTO `employee` VALUES ('3002', '员工B', '123123123', '部门A', '44123123');
INSERT INTO `employee` VALUES ('3003', '员工C', '123123123', '部门A', '23432');
INSERT INTO `employee` VALUES ('3004', '员工D', '123123123', '部门B', '100');
INSERT INTO `employee` VALUES ('3005', '员工E', '123123123', '部门B', '75');
INSERT INTO `employee` VALUES ('3006', '员工F', '123123123', '部门A', '12213213');
INSERT INTO `employee` VALUES ('3007', '员工G', '123123123', '部门A', '234');
INSERT INTO `employee` VALUES ('3008', '员工H', '123123123', '部门A', '234');
INSERT INTO `employee` VALUES ('3009', '员工I', '123123123', '部门B', '234');
INSERT INTO `employee` VALUES ('3010', '员工J', '123123123', '部门B', '234');

SET FOREIGN_KEY_CHECKS = 1;
