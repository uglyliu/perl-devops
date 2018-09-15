/*
 Navicat Premium Data Transfer

 Source Server         : 47.92.78.127
 Source Server Type    : PostgreSQL
 Source Server Version : 100005
 Source Host           : 47.92.78.127:5432
 Source Catalog        : postgres
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 100005
 File Encoding         : 65001

 Date: 15/09/2018 14:58:01
*/


-- ----------------------------
-- Table structure for server
-- ----------------------------
DROP TABLE IF EXISTS "public"."server";
CREATE TABLE "public"."server" (
  "id" int4 NOT NULL DEFAULT NULL,
  "manageIp" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "sn" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "manufacturer" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "model" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "platform" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "version" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "cpuCount " int2 DEFAULT NULL,
  "cpuPhysicalCount" int2 DEFAULT NULL,
  "cpuModel " varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "createDate" timestamp(6) DEFAULT NULL,
  "createUser" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "updateUser" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "updateDate" timestamp(6) DEFAULT NULL,
  "mac" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "serialNum" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "portNum " int2 DEFAULT NULL,
  "intranetIp" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."server"."id" IS '资产id';
COMMENT ON COLUMN "public"."server"."manageIp" IS '管理IP';
COMMENT ON COLUMN "public"."server"."sn" IS 'SN号';
COMMENT ON COLUMN "public"."server"."manufacturer" IS '制造商';
COMMENT ON COLUMN "public"."server"."model" IS '型号';
COMMENT ON COLUMN "public"."server"."platform" IS '系统';
COMMENT ON COLUMN "public"."server"."version" IS '系统版本';
COMMENT ON COLUMN "public"."server"."cpuCount " IS 'CPU个数';
COMMENT ON COLUMN "public"."server"."cpuPhysicalCount" IS 'CPU物理个数';
COMMENT ON COLUMN "public"."server"."cpuModel " IS 'CPU型号';
COMMENT ON COLUMN "public"."server"."mac" IS 'mac地址';
COMMENT ON COLUMN "public"."server"."serialNum" IS '主机序列号';
COMMENT ON COLUMN "public"."server"."name" IS '服务器名称';
COMMENT ON COLUMN "public"."server"."portNum " IS '端口个数';
COMMENT ON COLUMN "public"."server"."intranetIp" IS '内网ip';
COMMENT ON TABLE "public"."server" IS '服务器表';

-- ----------------------------
-- Primary Key structure for table server
-- ----------------------------
ALTER TABLE "public"."server" ADD CONSTRAINT "server_pkey" PRIMARY KEY ("id");
