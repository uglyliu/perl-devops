/*
 Navicat Premium Data Transfer

 Source Server         : localhost_postgresql
 Source Server Type    : PostgreSQL
 Source Server Version : 100004
 Source Host           : localhost:5432
 Source Catalog        : postgres
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 100004
 File Encoding         : 65001

 Date: 13/09/2018 18:30:07
*/


-- ----------------------------
-- Table structure for product_version
-- ----------------------------
DROP TABLE IF EXISTS "public"."product_version";
CREATE TABLE "public"."product_version" (
  "id" int4 NOT NULL DEFAULT NULL,
  "productId" int4 DEFAULT NULL,
  "versionName" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "productManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "startTime" timestamp(6) DEFAULT NULL,
  "endTime" timestamp(6) DEFAULT NULL,
  "versionWiki" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "versionStatus" int2 DEFAULT NULL,
  "versionEnv" int2 DEFAULT NULL,
  "productContact" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "devManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "devContact" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "qaManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "qaContact" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "safeManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "safeContact" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "createDate" timestamp(6) DEFAULT NULL,
  "updateDate" timestamp(6) DEFAULT NULL,
  "createUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "updateUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."product_version"."id" IS '版本id';
COMMENT ON COLUMN "public"."product_version"."productId" IS '产品id';
COMMENT ON COLUMN "public"."product_version"."versionName" IS '版本名称';
COMMENT ON COLUMN "public"."product_version"."productManager" IS '版本负责人';
COMMENT ON COLUMN "public"."product_version"."startTime" IS '版本开始时间';
COMMENT ON COLUMN "public"."product_version"."endTime" IS '版本结束时间';
COMMENT ON COLUMN "public"."product_version"."versionWiki" IS '版本需求wiki地址';
COMMENT ON COLUMN "public"."product_version"."versionStatus" IS '版本状态（需求收集、需求评审、ui评审、立项、排期、开发、测试、安全测试、发布、验收）
';
COMMENT ON COLUMN "public"."product_version"."versionEnv" IS '版本所处环境（未开始、测试、uat、预热、生产）';

-- ----------------------------
-- Primary Key structure for table product_version
-- ----------------------------
ALTER TABLE "public"."product_version" ADD CONSTRAINT "product_version_pkey" PRIMARY KEY ("id");
