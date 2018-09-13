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

 Date: 13/09/2018 18:30:12
*/


-- ----------------------------
-- Table structure for template
-- ----------------------------
DROP TABLE IF EXISTS "public"."template";
CREATE TABLE "public"."template" (
  "id" int4 NOT NULL DEFAULT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "path" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "tag" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "status" int2 DEFAULT NULL,
  "createDate" timestamp(6) DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."template"."id" IS '模板id';
COMMENT ON COLUMN "public"."template"."name" IS '模板名称';
COMMENT ON COLUMN "public"."template"."path" IS '模板地址';
COMMENT ON COLUMN "public"."template"."tag" IS '模板标签';
COMMENT ON COLUMN "public"."template"."status" IS '是否启用';
COMMENT ON TABLE "public"."template" IS '模板表';

-- ----------------------------
-- Primary Key structure for table template
-- ----------------------------
ALTER TABLE "public"."template" ADD CONSTRAINT "template_pkey" PRIMARY KEY ("id");
