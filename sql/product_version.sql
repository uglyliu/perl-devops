/*
Navicat PGSQL Data Transfer

Source Server         : 47.92.78.127
Source Server Version : 100500
Source Host           : 47.92.78.127:5432
Source Database       : postgres
Source Schema         : public

Target Server Type    : PGSQL
Target Server Version : 100500
File Encoding         : 65001

Date: 2018-09-09 17:57:18
*/


-- ----------------------------
-- Table structure for product_version
-- ----------------------------
DROP TABLE IF EXISTS "public"."product_version";
CREATE TABLE "public"."product_version" (
"id" int4 NOT NULL,
"productId" int4,
"versionName" varchar(255) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of product_version
-- ----------------------------

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table product_version
-- ----------------------------
ALTER TABLE "public"."product_version" ADD PRIMARY KEY ("id");
