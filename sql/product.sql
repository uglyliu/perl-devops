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

 Date: 15/09/2018 14:58:16
*/


-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS "public"."product";
CREATE TABLE "public"."product" (
  "id" int4 NOT NULL DEFAULT nextval('product_id_seq'::regclass),
  "productName" varchar(40) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "productDesc" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "productStatus" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "productManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "productContact" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "devManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "devContact" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "qaManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "qaContact" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "safeManager" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "safeContact" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "onlineVersion" varchar(30) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "productWiki" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "createDate" timestamp(0) DEFAULT NULL::timestamp without time zone,
  "updateDate" timestamp(0) DEFAULT NULL::timestamp without time zone,
  "createUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "updateUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "lastOnline" timestamp(0) DEFAULT NULL::timestamp without time zone,
  "productTags" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;
COMMENT ON COLUMN "public"."product"."productName" IS '产品名称';
COMMENT ON COLUMN "public"."product"."productDesc" IS '产品描述';
COMMENT ON COLUMN "public"."product"."productStatus" IS '当前产品状态';
COMMENT ON COLUMN "public"."product"."productManager" IS '默认产品负责人';
COMMENT ON COLUMN "public"."product"."productContact" IS '默认产品负责人联系方式';
COMMENT ON COLUMN "public"."product"."devManager" IS '默认开发负责人';
COMMENT ON COLUMN "public"."product"."devContact" IS '默认开发负责人联系方式';
COMMENT ON COLUMN "public"."product"."qaManager" IS '默认测试负责人';
COMMENT ON COLUMN "public"."product"."qaContact" IS '默认测试负责人联系方式';
COMMENT ON COLUMN "public"."product"."safeManager" IS '默认安全负责人';
COMMENT ON COLUMN "public"."product"."safeContact" IS '默认安全负责人联系方式';
COMMENT ON COLUMN "public"."product"."onlineVersion" IS '当前线上版本';
COMMENT ON COLUMN "public"."product"."productWiki" IS '产品wiki地址';
COMMENT ON COLUMN "public"."product"."lastOnline" IS '最近一次上线日期';
COMMENT ON COLUMN "public"."product"."productTags" IS '产品标签';
COMMENT ON TABLE "public"."product" IS '产品线表';

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO "public"."product" VALUES (1, '支付系统', '提供支付、查询等功能', 'v2.0开发中', '张无忌', '10086', '张三丰', '10087', '花无缺', '10088', '小鱼儿', '10089', 'v1.1.0', 'https://mojolicious.org', NULL, NULL, NULL, NULL, '2018-09-04 12:03:43', NULL);
INSERT INTO "public"."product" VALUES (2, '领券系统', '提供领取优惠券的功能', '等待新需求', '张日山', '20086', '张起灵', '20087', '张启山', '10088', '张副官', '10089', 'v2.0.0', 'https://metacpan.org', NULL, NULL, NULL, NULL, '2018-09-05 14:04:33', NULL);
INSERT INTO "public"."product" VALUES (4, '商品系统', '丰富的促销功能,让您促销活动随时做,商品特价、满赠、预售以及订单红包等活动形式多样,结合订货宝特有的游客模式、开放注册与商品分享,让您迅速拓展渠道。', '新创建', '紫霞仙子', 'zi-xia-xian-zi@gmail.com', '至尊宝', 'zhi-zun-bao@gmail.com', '铁扇公主', 'tie-shan@gmail.com', '蜘蛛精', 'zhi-zhu-jing@gmail.com', NULL, 'https://github.com/mojolicious/mojo-pg', '2018-09-09 16:32:16', '2018-09-09 17:08:32', 'admin', 'admin', NULL, NULL);

-- ----------------------------
-- Primary Key structure for table product
-- ----------------------------
ALTER TABLE "public"."product" ADD CONSTRAINT "product_pkey" PRIMARY KEY ("id");
