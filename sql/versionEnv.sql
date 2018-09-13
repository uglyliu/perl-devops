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

 Date: 13/09/2018 18:30:17
*/


-- ----------------------------
-- Table structure for versionEnv
-- ----------------------------
DROP TABLE IF EXISTS "public"."versionEnv";
CREATE TABLE "public"."versionEnv" (
  "id" int4 NOT NULL DEFAULT NULL,
  "versionId" int4 DEFAULT NULL,
  "tag" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "env" int2 DEFAULT NULL,
  "imageType" int2 DEFAULT NULL,
  "deployType" int2 DEFAULT NULL,
  "createDate" timestamp(6) DEFAULT NULL,
  "createUser" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "updateDate" timestamp(6) DEFAULT NULL,
  "updateUser" varchar COLLATE "pg_catalog"."default" DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."versionEnv"."id" IS '主键';
COMMENT ON COLUMN "public"."versionEnv"."versionId" IS '版本id';
COMMENT ON COLUMN "public"."versionEnv"."env" IS '环境';
COMMENT ON TABLE "public"."versionEnv" IS '版本环境配置';
