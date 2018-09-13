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

 Date: 13/09/2018 18:30:22
*/


-- ----------------------------
-- Table structure for asset
-- ----------------------------
DROP TABLE IF EXISTS "public"."asset";
CREATE TABLE "public"."asset" (
  "id" int4 NOT NULL DEFAULT NULL,
  "assetType" int2 DEFAULT NULL,
  "ip" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "host" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "mac" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "user" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "password" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "os" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "status" int2 DEFAULT NULL,
  "config" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "serialNum" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "assetNum" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "activeDate" timestamp(6) DEFAULT NULL,
  "createDate" timestamp(6) DEFAULT NULL,
  "createUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "updateDate" timestamp(6) DEFAULT NULL,
  "updateUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."asset"."id" IS '资产id';
COMMENT ON COLUMN "public"."asset"."assetType" IS '资产类型';
COMMENT ON COLUMN "public"."asset"."ip" IS 'ip地址';
COMMENT ON COLUMN "public"."asset"."host" IS '主机名';
COMMENT ON COLUMN "public"."asset"."mac" IS 'mac地址';
COMMENT ON COLUMN "public"."asset"."user" IS '主机用户';
COMMENT ON COLUMN "public"."asset"."password" IS '主机密码';
COMMENT ON COLUMN "public"."asset"."os" IS '操作系统信息';
COMMENT ON COLUMN "public"."asset"."status" IS '资产状态';
COMMENT ON COLUMN "public"."asset"."config" IS '资产配置信息';
COMMENT ON COLUMN "public"."asset"."serialNum" IS '主机序列号';
COMMENT ON COLUMN "public"."asset"."assetNum" IS '资产号';
COMMENT ON COLUMN "public"."asset"."activeDate" IS '资产投入使用日期';
COMMENT ON TABLE "public"."asset" IS '资产表';
