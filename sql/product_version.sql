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

 Date: 15/09/2018 14:58:09
*/


-- ----------------------------
-- Table structure for product_version
-- ----------------------------
DROP TABLE IF EXISTS "public"."product_version";
CREATE TABLE "public"."product_version" (
  "id" int4 NOT NULL DEFAULT nextval('version_id_seq'::regclass),
  "productId" int4 DEFAULT NULL,
  "versionName" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "productManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "startTime" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "endTime" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "versionWiki" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "versionStatus" int2 DEFAULT NULL,
  "versionEnv" int2 DEFAULT NULL,
  "productContact" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "devManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "devContact" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "qaManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "qaContact" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "safeManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "safeContact" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "createDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "updateDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "createUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "updateUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
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
-- Records of product_version
-- ----------------------------
INSERT INTO "public"."product_version" VALUES (5, 2, 'v2.0.0', '张三丰', '2019-01-02 00:00:00', '2020-01-02 00:00:00', 'http://github.com', 4, 0, '20086', '张起灵', '20087', '张启山', '10088', '张副官', '10089', '2018-09-14 10:51:21', NULL, 'admin', NULL);
INSERT INTO "public"."product_version" VALUES (6, 1, 'v1.0.0', '张无忌', '2017-01-02 00:00:00', '2017-05-02 00:00:00', 'http://github.com', 0, 0, '10086', '张三丰', '10087', '花无缺', '10088', '小鱼儿', '10089', '2018-09-14 11:03:46', NULL, 'admin', NULL);
INSERT INTO "public"."product_version" VALUES (7, 4, 'v1.0.0', '紫霞仙子', '2017-01-02 00:00:00', '2017-05-02 00:00:00', 'http://github.com', 2, 0, 'zi-xia-xian-zi@gmail.com', '至尊宝', 'zhi-zun-bao@gmail.com', '铁扇公主', 'tie-shan@gmail.com', '蜘蛛精', 'zhi-zhu-jing@gmail.com', '2018-09-14 11:05:53', NULL, 'admin', NULL);
INSERT INTO "public"."product_version" VALUES (4, 2, 'v1.0.0', '张日山', '2018-01-02 00:00:00', '2019-01-02 00:00:00', 'http://github.com', 2, 0, '20086', '张起灵', '20087', '张启山', '10088', '张副官', '10089', '2018-09-14 10:50:57', '2018-09-15 09:27:38', 'admin', 'admin');
INSERT INTO "public"."product_version" VALUES (8, 1, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-09-15 14:23:28', NULL, 'admin', NULL);

-- ----------------------------
-- Primary Key structure for table product_version
-- ----------------------------
ALTER TABLE "public"."product_version" ADD CONSTRAINT "product_version_pkey" PRIMARY KEY ("id");
