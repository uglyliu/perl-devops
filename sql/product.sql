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

Date: 2018-09-08 18:11:03
*/


-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS "public"."product";
CREATE TABLE "public"."product" (
"id" int4 DEFAULT nextval('product_id_seq'::regclass) NOT NULL,
"productName" varchar(40) COLLATE "default",
"productDesc" varchar(255) COLLATE "default",
"productStatus" varchar(50) COLLATE "default",
"prouctManager" varchar(20) COLLATE "default",
"productContact" varchar(30) COLLATE "default",
"devManager" varchar(20) COLLATE "default",
"devContact" varchar(30) COLLATE "default",
"qaManager" varchar(20) COLLATE "default",
"qaContact" varchar(30) COLLATE "default",
"safeManager" varchar(20) COLLATE "default",
"safeContact" varchar(30) COLLATE "default"
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "public"."product" IS '产品线表';
COMMENT ON COLUMN "public"."product"."productName" IS '产品名称';
COMMENT ON COLUMN "public"."product"."productDesc" IS '产品描述';
COMMENT ON COLUMN "public"."product"."productStatus" IS '当前产品状态';
COMMENT ON COLUMN "public"."product"."prouctManager" IS '默认产品负责人';
COMMENT ON COLUMN "public"."product"."productContact" IS '默认产品负责人联系方式';
COMMENT ON COLUMN "public"."product"."devManager" IS '默认开发负责人';
COMMENT ON COLUMN "public"."product"."devContact" IS '默认开发负责人联系方式';
COMMENT ON COLUMN "public"."product"."qaManager" IS '默认测试负责人';
COMMENT ON COLUMN "public"."product"."qaContact" IS '默认测试负责人联系方式';
COMMENT ON COLUMN "public"."product"."safeManager" IS '默认安全负责人';
COMMENT ON COLUMN "public"."product"."safeContact" IS '默认安全负责人联系方式';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table product
-- ----------------------------
ALTER TABLE "public"."product" ADD PRIMARY KEY ("id");
