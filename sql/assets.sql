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

 Date: 15/09/2018 14:57:51
*/


-- ----------------------------
-- Table structure for assets
-- ----------------------------
DROP TABLE IF EXISTS "public"."assets";
CREATE TABLE "public"."assets" (
  "id" int8 NOT NULL DEFAULT nextval('assets_id_seq'::regclass),
  "assetType" int2 DEFAULT NULL,
  "status" int2 DEFAULT NULL,
  "activeDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "createDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "createUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "updateDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "updateUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "idc" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "cabinetNo" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "cabinetOrder" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "tags" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "productName" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."assets"."id" IS '资产id';
COMMENT ON COLUMN "public"."assets"."assetType" IS '资产类型(服务器、交换机、防火墙)';
COMMENT ON COLUMN "public"."assets"."status" IS '资产状态';
COMMENT ON COLUMN "public"."assets"."activeDate" IS '资产投入使用日期';
COMMENT ON COLUMN "public"."assets"."idc" IS 'IDC机房(机房、楼层)';
COMMENT ON COLUMN "public"."assets"."cabinetNo" IS '机柜号';
COMMENT ON COLUMN "public"."assets"."cabinetOrder" IS '机柜中序号';
COMMENT ON COLUMN "public"."assets"."tags" IS '资产标签';
COMMENT ON COLUMN "public"."assets"."productName" IS '属于哪个产品线';
COMMENT ON TABLE "public"."assets" IS '资产表';

-- ----------------------------
-- Records of assets
-- ----------------------------
INSERT INTO "public"."assets" VALUES (100003, 0, 1, NULL, '2018-09-15 14:52:18', 'admin', NULL, NULL, '', '', '', '', '');
INSERT INTO "public"."assets" VALUES (100004, 1, 1, NULL, '2018-09-15 14:54:08', 'admin', NULL, NULL, '', '', '', '', NULL);
INSERT INTO "public"."assets" VALUES (100005, 2, 2, NULL, '2018-09-15 14:55:07', 'admin', NULL, NULL, '', '', '', '高性能、多核', NULL);

-- ----------------------------
-- Primary Key structure for table assets
-- ----------------------------
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_pkey" PRIMARY KEY ("id");
