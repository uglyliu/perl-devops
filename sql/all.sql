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

 Date: 27/11/2018 17:26:51
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
  "idc" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "cabinetNo" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "cabinetOrder" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "tags" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "productName" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
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
INSERT INTO "public"."assets" VALUES (100011, 0, 0, NULL, '2018-09-16 14:17:16', 'admin', NULL, NULL, '', '', '', '', NULL);
INSERT INTO "public"."assets" VALUES (100010, 2, 1, NULL, '2018-09-16 14:10:54', 'admin', '2018-09-18 10:17:03', 'admin', '', '', '', 'nginx haproxy', NULL);

-- ----------------------------
-- Table structure for kube_cluster
-- ----------------------------
DROP TABLE IF EXISTS "public"."kube_cluster";
CREATE TABLE "public"."kube_cluster" (
  "id" int2 NOT NULL DEFAULT nextval('kube_cluster_id_seq'::regclass),
  "ip" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL,
  "type" varchar(16) COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL,
  "ssh" int2 NOT NULL DEFAULT NULL,
  "cluster" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL,
  "user" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "password" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "port" int2 DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."kube_cluster"."id" IS '主键';
COMMENT ON COLUMN "public"."kube_cluster"."ip" IS '服务器ip地址';
COMMENT ON COLUMN "public"."kube_cluster"."type" IS '类型：master/node';
COMMENT ON COLUMN "public"."kube_cluster"."ssh" IS '是否已经配置过ssh：1是0否';
COMMENT ON COLUMN "public"."kube_cluster"."cluster" IS '所属集群，集群唯一标识';
COMMENT ON TABLE "public"."kube_cluster" IS 'kube集群节点表';

-- ----------------------------
-- Records of kube_cluster
-- ----------------------------
INSERT INTO "public"."kube_cluster" VALUES (4, '172.22.132.14', 'node', 0, 'Test', 'root', 'root', 22);
INSERT INTO "public"."kube_cluster" VALUES (3, '172.22.132.13', 'master', 0, 'Test', 'root', 'root', 22);
INSERT INTO "public"."kube_cluster" VALUES (2, '172.22.132.12', 'master', 0, 'Test', 'root', 'root', 22);
INSERT INTO "public"."kube_cluster" VALUES (1, '172.22.132.11', 'master', 0, 'Test', 'root', 'root', 22);

-- ----------------------------
-- Table structure for kube_config
-- ----------------------------
DROP TABLE IF EXISTS "public"."kube_config";
CREATE TABLE "public"."kube_config" (
  "id" int4 NOT NULL DEFAULT nextval('kube_config_id_seq'::regclass),
  "kubeName" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "kubeVersion" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "kubeCniVersion" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "etcdVersion" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "dockerVersion" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "netMode" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "clusterIP" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "serviceClusterIP" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "dnsIP" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "dnsDN" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "kube_api_ip" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "ingressVIP" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "sshUser" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "sshPort" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "masterAddress" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "masterHostName" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "nodeHostName" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "etcdAddress" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "yamlDir" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "nodePort" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "kubeToken" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "loadBalance" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "kubeDesc" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "createDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "createUser" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "updateDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "updateUser" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "keepalivedAddress" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "nodeAddress" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "etcd_ca_dir" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "kube_dir" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "kube_api_port" int2 DEFAULT NULL,
  "deploy" int2 DEFAULT NULL,
  "etcd_default_port" int2 DEFAULT NULL,
  "haproxy_default_port" int2 DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."kube_config"."kubeName" IS '集群标识';
COMMENT ON COLUMN "public"."kube_config"."kubeVersion" IS 'k8s版本';
COMMENT ON COLUMN "public"."kube_config"."kubeCniVersion" IS 'CNI版本';
COMMENT ON COLUMN "public"."kube_config"."etcdVersion" IS 'etcd版本';
COMMENT ON COLUMN "public"."kube_config"."dockerVersion" IS 'Docker版本';
COMMENT ON COLUMN "public"."kube_config"."netMode" IS 'k8s网络模型';
COMMENT ON COLUMN "public"."kube_config"."clusterIP" IS 'Cluster IP CIDR';
COMMENT ON COLUMN "public"."kube_config"."serviceClusterIP" IS 'Service Cluster IP CIDR';
COMMENT ON COLUMN "public"."kube_config"."dnsIP" IS 'Service DNS IP CIDR';
COMMENT ON COLUMN "public"."kube_config"."dnsDN" IS 'DNS DN';
COMMENT ON COLUMN "public"."kube_config"."kube_api_ip" IS 'Kubernetes API VIP';
COMMENT ON COLUMN "public"."kube_config"."ingressVIP" IS 'Kubernetes Ingress VIP';
COMMENT ON COLUMN "public"."kube_config"."sshUser" IS 'SSH用户';
COMMENT ON COLUMN "public"."kube_config"."sshPort" IS 'SSH端口';
COMMENT ON COLUMN "public"."kube_config"."masterAddress" IS 'Master节点地址';
COMMENT ON COLUMN "public"."kube_config"."masterHostName" IS 'Master节点HostName前缀';
COMMENT ON COLUMN "public"."kube_config"."nodeHostName" IS 'Node节点HostName前缀';
COMMENT ON COLUMN "public"."kube_config"."etcdAddress" IS 'etcd集群地址';
COMMENT ON COLUMN "public"."kube_config"."yamlDir" IS 'YAML主目录';
COMMENT ON COLUMN "public"."kube_config"."nodePort" IS 'NodePort端口';
COMMENT ON COLUMN "public"."kube_config"."kubeToken" IS 'token';
COMMENT ON COLUMN "public"."kube_config"."loadBalance" IS '负载均衡器配置';
COMMENT ON COLUMN "public"."kube_config"."kubeDesc" IS '集群描述';
COMMENT ON COLUMN "public"."kube_config"."keepalivedAddress" IS 'keepalived地址';
COMMENT ON COLUMN "public"."kube_config"."nodeAddress" IS '初始node节点';
COMMENT ON COLUMN "public"."kube_config"."etcd_ca_dir" IS 'etcd的CA所在目录';
COMMENT ON COLUMN "public"."kube_config"."kube_dir" IS 'kubernetes安装目录';
COMMENT ON COLUMN "public"."kube_config"."kube_api_port" IS 'Kubernetes API VIP端口';
COMMENT ON COLUMN "public"."kube_config"."deploy" IS '是否已经部署过1是0否';
COMMENT ON COLUMN "public"."kube_config"."etcd_default_port" IS 'etcd端口';
COMMENT ON COLUMN "public"."kube_config"."haproxy_default_port" IS 'haproxy端口';

-- ----------------------------
-- Records of kube_config
-- ----------------------------
INSERT INTO "public"."kube_config" VALUES (1, 'Test', 'v1.11.0', 'v0.7.1', 'v3.3.8', 'v18.05.0-ce', 'Calico-v3.1', '10.244.0.0/16', '10.96.0.0/12', '10.96.0.10', 'cluster.local', '172.22.132.15', '172.22.132.16', 'root', '2222|2200|2201|2202|2203|2204', '172.22.132.1[1-3]', 'k8s', 'k8s', '172.22.132.1[1-3]', '/root', '8090', NULL, 'HaProxy', '    描述                    
                        ', '2018-09-20 17:59:33', 'admin', NULL, NULL, '172.22.132.1[1-3]', '172.22.132.14', '/etc/etcd/ssl', '/etc/kubernetes', 6443, NULL, NULL, 6443);

-- ----------------------------
-- Table structure for minion_jobs
-- ----------------------------
DROP TABLE IF EXISTS "public"."minion_jobs";
CREATE TABLE "public"."minion_jobs" (
  "id" int8 NOT NULL DEFAULT nextval('minion_jobs_id_seq'::regclass),
  "args" jsonb NOT NULL DEFAULT NULL,
  "created" timestamptz(6) NOT NULL DEFAULT now(),
  "delayed" timestamptz(6) NOT NULL DEFAULT NULL,
  "finished" timestamptz(6) DEFAULT NULL,
  "priority" int4 NOT NULL DEFAULT NULL,
  "result" jsonb DEFAULT NULL,
  "retried" timestamptz(6) DEFAULT NULL,
  "retries" int4 NOT NULL DEFAULT 0,
  "started" timestamptz(6) DEFAULT NULL,
  "state" "public"."minion_state" NOT NULL DEFAULT 'inactive'::minion_state,
  "task" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL,
  "worker" int8 DEFAULT NULL,
  "queue" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'default'::text,
  "attempts" int4 NOT NULL DEFAULT 1,
  "parents" int8[] NOT NULL DEFAULT '{}'::bigint[],
  "notes" jsonb NOT NULL DEFAULT '{}'::jsonb
)
;

-- ----------------------------
-- Table structure for minion_locks
-- ----------------------------
DROP TABLE IF EXISTS "public"."minion_locks";
CREATE UNLOGGED TABLE "public"."minion_locks" (
  "id" int8 NOT NULL DEFAULT nextval('minion_locks_id_seq'::regclass),
  "name" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL,
  "expires" timestamptz(6) NOT NULL DEFAULT NULL
)
;

-- ----------------------------
-- Table structure for minion_workers
-- ----------------------------
DROP TABLE IF EXISTS "public"."minion_workers";
CREATE TABLE "public"."minion_workers" (
  "id" int8 NOT NULL DEFAULT nextval('minion_workers_id_seq'::regclass),
  "host" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL,
  "pid" int4 NOT NULL DEFAULT NULL,
  "started" timestamptz(6) NOT NULL DEFAULT now(),
  "notified" timestamptz(6) NOT NULL DEFAULT now(),
  "inbox" jsonb NOT NULL DEFAULT '[]'::jsonb,
  "status" jsonb NOT NULL DEFAULT '{}'::jsonb
)
;

-- ----------------------------
-- Table structure for mojo_migrations
-- ----------------------------
DROP TABLE IF EXISTS "public"."mojo_migrations";
CREATE TABLE "public"."mojo_migrations" (
  "name" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL,
  "version" int8 NOT NULL DEFAULT NULL
)
;

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
INSERT INTO "public"."product" VALUES (4, '商品系统', '                                                丰富的促销功能,让您促销活动随时做,商品特价、满赠、预售以及订单红包等活动形式多样,结合订货宝特有的游客模式、开放注册与商品分享,让您迅速拓展渠道。
                        
                        ', '新创建', '紫霞仙子', 'zi-xia-xian-zi@gmail.com', '至尊宝', 'zhi-zun-bao@gmail.com', '铁扇公主', 'tie-shan@gmail.com', '蜘蛛精', 'zhi-zhu-jing@gmail.com', NULL, 'https://github.com/mojolicious/mojo-pg', '2018-09-09 16:32:16', '2018-09-20 18:00:44', 'admin', 'admin', NULL, NULL);

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
  "updateUser" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "tags" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
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
COMMENT ON COLUMN "public"."product_version"."tags" IS '标签';

-- ----------------------------
-- Records of product_version
-- ----------------------------
INSERT INTO "public"."product_version" VALUES (5, 2, 'v2.0.0', '张三丰', '2019-01-02 00:00:00', '2020-01-02 00:00:00', 'http://github.com', 4, 0, '20086', '张起灵', '20087', '张启山', '10088', '张副官', '10089', '2018-09-14 10:51:21', NULL, 'admin', NULL, NULL);
INSERT INTO "public"."product_version" VALUES (6, 1, 'v1.0.0', '张无忌', '2017-01-02 00:00:00', '2017-05-02 00:00:00', 'http://github.com', 0, 0, '10086', '张三丰', '10087', '花无缺', '10088', '小鱼儿', '10089', '2018-09-14 11:03:46', NULL, 'admin', NULL, NULL);
INSERT INTO "public"."product_version" VALUES (7, 4, 'v1.0.0', '紫霞仙子', '2017-01-02 00:00:00', '2017-05-02 00:00:00', 'http://github.com', 2, 0, 'zi-xia-xian-zi@gmail.com', '至尊宝', 'zhi-zun-bao@gmail.com', '铁扇公主', 'tie-shan@gmail.com', '蜘蛛精', 'zhi-zhu-jing@gmail.com', '2018-09-14 11:05:53', NULL, 'admin', NULL, NULL);
INSERT INTO "public"."product_version" VALUES (4, 2, 'v1.0.0', '张日山', '2018-01-02 00:00:00', '2019-01-02 00:00:00', 'http://github.com', 2, 0, '20086', '张起灵', '20087', '张启山', '10088', '张副官', '10089', '2018-09-14 10:50:57', '2018-09-15 09:27:38', 'admin', 'admin', NULL);

-- ----------------------------
-- Table structure for server
-- ----------------------------
DROP TABLE IF EXISTS "public"."server";
CREATE TABLE "public"."server" (
  "id" int4 NOT NULL DEFAULT NULL,
  "manageIp" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "sn" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "manufacturer" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "model" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "platform" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "version" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "cpuCount " int2 DEFAULT NULL,
  "cpuPhysicalCount" int2 DEFAULT NULL,
  "cpuModel " varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "createDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "createUser" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "updateUser" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "updateDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "mac" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "serialNum" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "portNum " int2 DEFAULT NULL,
  "intranetIp" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "user" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "ip" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "port" int2 DEFAULT NULL,
  "desc" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
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
COMMENT ON COLUMN "public"."server"."user" IS '用户名';
COMMENT ON COLUMN "public"."server"."ip" IS 'ip地址';
COMMENT ON COLUMN "public"."server"."port" IS '端口';
COMMENT ON COLUMN "public"."server"."desc" IS '描述';
COMMENT ON TABLE "public"."server" IS '服务器表';

-- ----------------------------
-- Records of server
-- ----------------------------
INSERT INTO "public"."server" VALUES (100010, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-09-16 14:10:54', 'admin', 'admin', '2018-09-16 14:18:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."server" VALUES (100011, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-09-16 14:17:16', 'admin', 'admin', '2018-09-16 14:21:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for template
-- ----------------------------
DROP TABLE IF EXISTS "public"."template";
CREATE TABLE "public"."template" (
  "id" int4 NOT NULL DEFAULT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "path" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "tag" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "status" int2 DEFAULT NULL,
  "createDate" timestamp(6) DEFAULT NULL::timestamp without time zone
)
;
COMMENT ON COLUMN "public"."template"."id" IS '模板id';
COMMENT ON COLUMN "public"."template"."name" IS '模板名称';
COMMENT ON COLUMN "public"."template"."path" IS '模板地址';
COMMENT ON COLUMN "public"."template"."tag" IS '模板标签';
COMMENT ON COLUMN "public"."template"."status" IS '是否启用';
COMMENT ON TABLE "public"."template" IS '模板表';

-- ----------------------------
-- Table structure for versionEnv
-- ----------------------------
DROP TABLE IF EXISTS "public"."versionEnv";
CREATE TABLE "public"."versionEnv" (
  "id" int4 NOT NULL DEFAULT NULL,
  "versionId" int4 DEFAULT NULL,
  "tag" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "env" int2 DEFAULT NULL,
  "imageType" int2 DEFAULT NULL,
  "deployType" int2 DEFAULT NULL,
  "createDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "createUser" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "updateDate" timestamp(6) DEFAULT NULL::timestamp without time zone,
  "updateUser" varchar COLLATE "pg_catalog"."default" DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."versionEnv"."id" IS '主键';
COMMENT ON COLUMN "public"."versionEnv"."versionId" IS '版本id';
COMMENT ON COLUMN "public"."versionEnv"."env" IS '环境';
COMMENT ON TABLE "public"."versionEnv" IS '版本环境配置';

-- ----------------------------
-- Primary Key structure for table assets
-- ----------------------------
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table kube_cluster
-- ----------------------------
ALTER TABLE "public"."kube_cluster" ADD CONSTRAINT "node_ip" UNIQUE ("ip");
COMMENT ON CONSTRAINT "node_ip" ON "public"."kube_cluster" IS '服务器ip';

-- ----------------------------
-- Primary Key structure for table kube_cluster
-- ----------------------------
ALTER TABLE "public"."kube_cluster" ADD CONSTRAINT "kube_cluster_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table kube_config
-- ----------------------------
ALTER TABLE "public"."kube_config" ADD CONSTRAINT "kube_config_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table minion_jobs
-- ----------------------------
CREATE INDEX "minion_jobs_parents_idx" ON "public"."minion_jobs" USING gin (
  "parents" "pg_catalog"."array_ops"
);
CREATE INDEX "minion_jobs_state_priority_id_idx" ON "public"."minion_jobs" USING btree (
  "state" "pg_catalog"."enum_ops" ASC NULLS LAST,
  "priority" "pg_catalog"."int4_ops" DESC NULLS FIRST,
  "id" "pg_catalog"."int8_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table minion_jobs
-- ----------------------------
CREATE TRIGGER "minion_jobs_notify_workers_trigger" AFTER INSERT OR UPDATE OF "retries" ON "public"."minion_jobs"
FOR EACH ROW
EXECUTE PROCEDURE "public"."minion_jobs_notify_workers"();

-- ----------------------------
-- Checks structure for table minion_jobs
-- ----------------------------
ALTER TABLE "public"."minion_jobs" ADD CONSTRAINT "args" CHECK ((jsonb_typeof(args) = 'array'::text));
ALTER TABLE "public"."minion_jobs" ADD CONSTRAINT "minion_jobs_notes_check" CHECK ((jsonb_typeof(notes) = 'object'::text));

-- ----------------------------
-- Primary Key structure for table minion_jobs
-- ----------------------------
ALTER TABLE "public"."minion_jobs" ADD CONSTRAINT "minion_jobs_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table minion_locks
-- ----------------------------
CREATE INDEX "minion_locks_name_expires_idx" ON "public"."minion_locks" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "expires" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table minion_locks
-- ----------------------------
ALTER TABLE "public"."minion_locks" ADD CONSTRAINT "minion_locks_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Checks structure for table minion_workers
-- ----------------------------
ALTER TABLE "public"."minion_workers" ADD CONSTRAINT "minion_workers_inbox_check" CHECK ((jsonb_typeof(inbox) = 'array'::text));
ALTER TABLE "public"."minion_workers" ADD CONSTRAINT "minion_workers_status_check" CHECK ((jsonb_typeof(status) = 'object'::text));

-- ----------------------------
-- Primary Key structure for table minion_workers
-- ----------------------------
ALTER TABLE "public"."minion_workers" ADD CONSTRAINT "minion_workers_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table mojo_migrations
-- ----------------------------
ALTER TABLE "public"."mojo_migrations" ADD CONSTRAINT "mojo_migrations_name_key" UNIQUE ("name");

-- ----------------------------
-- Checks structure for table mojo_migrations
-- ----------------------------
ALTER TABLE "public"."mojo_migrations" ADD CONSTRAINT "mojo_migrations_version_check" CHECK ((version >= 0));

-- ----------------------------
-- Primary Key structure for table product
-- ----------------------------
ALTER TABLE "public"."product" ADD CONSTRAINT "product_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table product_version
-- ----------------------------
ALTER TABLE "public"."product_version" ADD CONSTRAINT "product_version_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table server
-- ----------------------------
ALTER TABLE "public"."server" ADD CONSTRAINT "server_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table template
-- ----------------------------
ALTER TABLE "public"."template" ADD CONSTRAINT "template_pkey" PRIMARY KEY ("id");
