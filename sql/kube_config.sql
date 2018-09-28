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

 Date: 28/09/2018 18:26:25
*/


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
  "kube_api_port" int2 DEFAULT NULL
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

-- ----------------------------
-- Records of kube_config
-- ----------------------------
INSERT INTO "public"."kube_config" VALUES (1, 'Test', 'v1.11.0', 'v0.7.1', 'v3.3.8', 'v18.05.0-ce', 'Calico-v3.1', '10.244.0.0/16', '10.96.0.0/12', '10.96.0.10', 'cluster.local', 'https://172.22.132.9:6443', '11.11.11.110', 'root', '2222|2200|2201|2202|2203|2204', '11.11.11.11[1-3]', 'k8s-', 'k8s-n', '11.11.11.11[1-3]', '/root', '8090', NULL, 'HaProxy', '    描述                    
                        ', '2018-09-20 17:59:33', 'admin', NULL, NULL, '11.11.11.11[4-6]', '11.11.11.11[4-6]', '/etc/etcd/ssl', '/etc/kubernetes', NULL);

-- ----------------------------
-- Primary Key structure for table kube_config
-- ----------------------------
ALTER TABLE "public"."kube_config" ADD CONSTRAINT "kube_config_pkey" PRIMARY KEY ("id");
